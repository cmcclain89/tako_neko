defmodule TakoNeko do
  @moduledoc """
  Documentation for `TakoNeko`.
  """

  alias TakoNeko.{Client}

  @doc """
  Hello world.

  ## Examples

      iex> TakoNeko.hello()
      :world

  """
  def get!(%TakoNeko.Request{} = request, path) do
    build_req(request, path)
    |> Req.get!()
    |> TakoNeko.Response.new(request.client)
  end

  def get!(%TakoNeko.Request{} = request, path, module) do
    build_req(request, path)
    |> Req.get!()
    |> TakoNeko.Response.new(request.client, module)
  end

  defp build_req(%TakoNeko.Request{} = request, path) do
    Req.new(
      url: url(request.client, path),
      headers: request.headers
    )
    |> put_auth(request.client)
    |> put_params(request)
  end

  defp url(%Client{base_url: base_url}, path) do
    base_url <> path
  end

  defp put_auth(%Req.Request{} = req, %Client{auth: auth}) do
    Req.merge(req, auth: auth)
  end

  defp put_auth(%Req.Request{} = req, _client), do: req

  defp put_params(%Req.Request{} = req, %TakoNeko.Request{query_params: params})
       when length(params) > 0 do
    Req.merge(req, params: params)
  end

  defp put_params(%Req.Request{} = req, _takoneko_request), do: req
end
