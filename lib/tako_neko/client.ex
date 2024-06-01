defmodule TakoNeko.Client do
  defstruct auth: nil, base_url: "https://api.github.com/"

  @type auth :: {:bearer, String.t()} | {:basic, String.t()}
  @type t :: %__MODULE__{base_url: binary}

  @spec new() :: t()
  def new(), do: %__MODULE__{}

  @spec new(auth()) :: t()
  def new({:bearer, _bearer_token} = auth), do: %__MODULE__{auth: auth}
end
