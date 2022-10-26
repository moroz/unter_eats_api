defmodule UnterEatsWeb.Api.Types.Products do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers

  object :product do
    field :id, non_null(:id)
    field :description_en, :string
    field :description_pl, :string
    field :name_en, :string
    field :name_pl, non_null(:string)
    field :price, :decimal
    field :slug, non_null(:string)

    timestamps()
  end
end
