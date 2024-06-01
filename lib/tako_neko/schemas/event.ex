defmodule TakoNeko.Schemas.Event do
  use TypedEctoSchema

  @primary_key false
  typed_embedded_schema do
    field(:id, :string, null: false)
    field(:type, :string, null: false)
    field(:actor, :map, null: false)
    field(:repo, :map, null: false)
    field(:payload, :map, null: false)
    field(:public, :boolean, null: false)
    field(:created_at, :naive_datetime, null: false)
    field(:org, :map, null: false)
  end
end
