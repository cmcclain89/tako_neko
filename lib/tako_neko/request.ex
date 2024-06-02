defmodule TakoNeko.Request do
  alias TakoNeko.Client

  defstruct [
    :client,
    :query_params,
    headers: %{"accept" => "application/vnd.github+json", "x-github-api-version" => "2022-11-28"}
  ]

  @type t :: %__MODULE__{
          client: Client.t(),
          query_params: keyword,
          headers: map
        }

  @spec new(Client.t(), keyword) :: t()
  def new(%Client{} = client, query_params \\ []) do
    %__MODULE__{client: client, query_params: query_params}
  end

  @spec new_with_headers(Client.t(), map, keyword) :: t()
  def new_with_headers(%Client{} = client, %{} = additional_headers, query_params \\ []) do
    %__MODULE__{client: client, query_params: query_params}
    |> add_headers(additional_headers)
  end

  @spec add_headers(t(), map) :: t()
  def add_headers(%__MODULE__{} = request, %{} = additional_headers) do
    %__MODULE__{request | headers: Map.merge(request.headers, additional_headers)}
  end
end
