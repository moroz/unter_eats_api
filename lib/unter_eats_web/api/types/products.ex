defmodule UnterEatsWeb.Api.Types.Products do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.ProductResolvers

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

  object :product_queries do
    field :product, :product do
      arg(:id, non_null(:id))
      resolve(&ProductResolvers.get_product/2)
    end
  end
end
