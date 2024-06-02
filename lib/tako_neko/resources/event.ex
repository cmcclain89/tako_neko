defmodule TakoNeko.Resources.Event do
  import TakoNeko
  alias TakoNeko.{Request, Schemas}

  # @spec list(Request.t(), String.t()) :: Req.Response.t()
  def list!(%Request{} = request, org) do
    get!(request, "/orgs/#{org}/events", Schemas.Event)
  end
end
