defmodule NoPassWeb.PairingController do
  use NoPassWeb, :controller

  defp random_string(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64() |> binary_part(0, length)
  end

  defp get_unused_token() do
    token = MnemonicSlugs.generate_slug(4)

    if NoPass.TokenStore.has_token?(token) do
      get_unused_token()
    else
      token
    end
  end

  def init_pairing(conn, %{"deviceId" => dev_id}) do
    token = get_unused_token()
    NoPass.TokenStore.store(token, %{dev_id: dev_id})
    json(conn, %{token: token})
  end

  def pair_with(conn, %{"token" => token, "deviceId" => dev_id_a}) do
    case NoPass.TokenStore.try_remove(token) do
      nil ->
        json(conn, %{error: "token expired"})

      %{:dev_id => dev_id_b} ->
        if dev_id_a == dev_id_b do
          NoPass.TokenStore.store(token, %{dev_id: dev_id_a})
          json(conn, %{error: "you can't pair with yourself!"})
        else
          # send to b the information of a
          NoPassWeb.Endpoint.broadcast!("private:" <> dev_id_b, "new_msg", %{
            type: "PairedWith",
            from: dev_id_a
          })

          # send to a the info of b
          json(conn, %{otherId: dev_id_b})
        end
    end
  end
end
