defmodule TakoNeko.Resources.Event do
  import TakoNeko
  alias TakoNeko.{Client, Schemas}

  @spec list(Client.t(), String.t(), keyword) :: Req.Response.t()
  def list(%Client{} = client, org, params \\ []) do
    get(client, "orgs/#{org}/events", params)
  end

  @spec cast_response(Req.Response.t()) :: [Schemas.Event.t()]
  def(cast_response(%Req.Response{} = response)) do
    case response.body do
      [%{} | _] ->
        Enum.map(response.body, fn event ->
          atomized_event =
            Enum.map(event, fn {k, v} ->
              {String.to_atom(k), v}
            end)

          struct(Schemas.Event, atomized_event)
        end)

      _ ->
        raise ArgumentError, "bummer!"
    end
  end
end
