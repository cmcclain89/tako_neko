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
  def get(%Client{} = client, path, params \\ []) do
    req =
      Req.new(
        url: url(client, path),
        headers: %{
          "accept" => "application/vnd.github+json",
          "x-github-api-version" => "2022-11-28"
        }
      )

    req =
      if client.auth do
        Req.merge(req, auth: client.auth)
      end

    req =
      if length(params) > 0 do
        Req.merge(req, params: params)
      end

    Req.get!(req)
  end

  defp url(%Client{base_url: base_url}, path) do
    base_url <> path
  end
end
