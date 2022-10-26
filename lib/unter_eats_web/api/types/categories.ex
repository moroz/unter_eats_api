defmodule UnterEatsWeb.Api.Types.Categories do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers

  object :category do
    field :id, non_null(:id)
    field :name_en, :string
    field :name_pl, non_null(:string)
    field :slug, non_null(:string)

    timestamps()
  end
end
