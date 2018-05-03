module Icons.Svg exposing (..)

import Svg exposing (Svg, svg, path)
import Svg.Attributes exposing (d, fill)
import Html.Attributes exposing (attribute)
import FeatherIcons exposing (customIcon)


devices =
    -- Created by combining .smartphone and .tablet
    customIcon
        [ path [ d "M5.615 2.537a2.56 2.56 0 0 0-2.601 2.348.866.866 0 0 0-.002.064c-.005.705 0 1.406-.002 2.11.573.001 1.15 0 1.73-.002.002-.677-.003-1.357.002-2.034.034-.377.459-.763.838-.755h.018c4.66.005 9.314-.011 13.966.01.247.018.42.131.567.35.149.222.225.544.185.815a.858.858 0 0 0-.01.125c-.003 1.497-.006 2.986-.005 4.479.572 0 1.148 0 1.73.014 0-1.497.003-2.996.006-4.489l-.01.125a2.886 2.886 0 0 0-.459-2.033c-.397-.592-1.074-1.06-1.89-1.115a.86.86 0 0 0-.055-.002c-4.672-.02-9.343-.004-14.008-.01zm6.89 12.102a.873.873 0 0 0-.09.007l-1.401-.002v1.731h.64v1.736h-.64v1.016c.005.244-.035.484-.104.715h1.48a.865.865 0 0 0 .266 0h2.666c-.118-.631-.052-1.101-.054-1.303v-.025-.403h-1.883v-1.734l1.88.002c-.001-.575.004-1.151.005-1.73l-2.64-.003a.87.87 0 0 0-.124-.007z", fill "currentColor", attribute "stroke" "none" ] []
        , path [ d "M2.448 8.556c2.043.016 4.088-.031 6.13.024.923.158.99 1.154.94 1.903v8.677c.023 1.02-1.055 1.274-1.865 1.179-1.814-.016-3.631.03-5.443-.024-.924-.159-.992-1.155-.94-1.904V9.734c-.016-.633.544-1.193 1.178-1.178z" ] []
        , path [ d "M17.555 11.442c1.544.011 3.09-.024 4.632.018.866.179.702 1.148.71 1.808-.011 2.122.025 4.247-.017 6.368-.18.866-1.15.702-1.809.71-1.232-.011-2.466.024-3.696-.018-.866-.179-.702-1.148-.71-1.808.011-2.122-.025-4.247.017-6.368a.892.892 0 0 1 .873-.71z" ] []
        ]
