defmodule UnterEatsWeb.Api.Types.Products do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.ProductResolvers
  import UnterEatsWeb.Api.Middleware.LazyPreload

  object :product do
    field :id, non_null(:id)
    field :description_en, :string
    field :description_pl, :string
    field :name_en, :string
    field :name_pl, non_null(:string)
    field :price, :decimal
    field :slug, non_null(:string)

    field :category, non_null(:category) do
      lazy_preload()
    end

    timestamps()
  end

  object :product_queries do
    field :product, :product do
      arg(:id, :id)
      arg(:slug, :string)
      resolve(&ProductResolvers.get_product/2)
    end

    field :products, non_null(list_of(non_null(:product))) do
      arg(:ids, non_null(list_of(non_null(:id))))
      resolve(&ProductResolvers.list_products/2)
    end
  end
end
