module Views.PasswordRequirements exposing (State, init, view, getNextPassword, getRequirements)

import Dict exposing (Dict)
import Random.Pcg.Extended as Random exposing (Seed)
import Element exposing (..)


--

import PasswordGenerator as PG exposing (PasswordRequirements)
import CharSet exposing (CharSet)
import Interval
import Helper
import Elements
import Styles


type alias State =
    { allowedSets : Select
    , atLeastOneOf : Select
    , includeCustom : String
    , excludeCustom : String
    , custom : String
    }


type Msg
    = SetIncludeCustom String
    | SetExcludeCustom String
    | SetCustom String
    | SetAllowed String Bool
    | SetAtLeastOneOff String Bool


update : Msg -> State -> State
update msg state =
    case msg of
        SetIncludeCustom s ->
            { state | includeCustom = s }

        SetExcludeCustom s ->
            { state | excludeCustom = s }

        SetCustom s ->
            { state | custom = s }

        SetAllowed s b ->
            { state | allowedSets = setSet s b state.allowedSets }

        SetAtLeastOneOff s b ->
            { state | atLeastOneOf = setSet s b state.atLeastOneOf }


setSet : comparable -> a -> Dict comparable ( a, b ) -> Dict comparable ( a, b )
setSet key b set =
    Dict.update key (Maybe.map (\( _, s ) -> ( b, s ))) set


isSelected : comparable -> Dict comparable ( Bool, a ) -> Bool
isSelected key select =
    Dict.get key select
        |> Maybe.map (\( b, _ ) -> b)
        |> Maybe.withDefault False


getRequirements : State -> PasswordRequirements
getRequirements state =
    -- TODO: change to allowed, to allow characters outside the ascii set if desired by user
    -- But do we really want to? UTF-8 isn't widely accepted and the user can always modify
    -- the generated password to his likes.
    { forbidden = getForbidden state.allowedSets state.includeCustom state.excludeCustom
    , atLeastOneOf = CharSet.fromString state.custom :: Helper.filterDict state.atLeastOneOf
    }



-- type Msg =
--     ToggleDetails
--     | CheckToggle Bool String CharSet


type alias Select =
    Dict String ( Bool, CharSet )


init : State
init =
    let
        mkSet b =
            Dict.map (\key s -> ( b, s )) CharSet.commonCharSets
    in
        { allowedSets = mkSet True, atLeastOneOf = mkSet True, includeCustom = "", excludeCustom = "", custom = "" }


getNextPassword : Int -> State -> Seed -> ( Result String String, Seed )
getNextPassword length reqs =
    Random.step (PG.randomPassword length (getRequirements reqs))


getForbidden sets include exclude =
    Interval.unionIntervalList
        (CharSet.fromString exclude)
        (Helper.filterDict (Dict.map (\k ( b, s ) -> ( not b, s )) sets)
            |> Interval.union
            |> Interval.subtract (CharSet.fromString include)
        )



-- View


view : (State -> msg) -> State -> Element msg
view toMsg state =
    column [ spacing (Styles.paddingScale 2) ]
        [ allowedChars state
        , atLeastOneOf state
        ]
        |> Element.map (\msg -> update msg state |> toMsg)


allowedChars state =
    Elements.inputGroup "Allowed Characters"
        [ toggleSets SetAllowed [] state.allowedSets
        , Elements.inputText [] (Just SetIncludeCustom) { label = "Include custom", placeholder = "" } state.includeCustom
        , Elements.inputText [] (Just SetExcludeCustom) { label = "Exclude custom", placeholder = "" } state.excludeCustom
        ]


atLeastOneOf state =
    Elements.inputGroup "At least one of"
        [ toggleSets SetAtLeastOneOff
            (Dict.foldl
                (\k ( b, _ ) acc ->
                    if b then
                        acc
                    else
                        k :: acc
                )
                []
                state.allowedSets
            )
            state.atLeastOneOf

        -- This was too confusing, so I just removed it
        -- , Elements.inputText "" [] (Just SetCustom) { label = "Custom", placeholder = "" } state.custom
        ]


toggleSets toMsg disabled set =
    row [ width shrink, spacing (Styles.paddingScale 1) ] (List.map (\l -> setBox toMsg (List.member l disabled) l set) [ "A-Z", "a-z", "0-9", "!\"#$%…" ])


setBox toMsg isDisabled label set =
    Elements.checkBox (toMsg label) isDisabled label (isSelected label set)
