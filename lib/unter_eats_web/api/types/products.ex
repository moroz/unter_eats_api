defmodule UnterEatsWeb.Api.Types.Products do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.ProductResolvers
  import UnterEatsWeb.Api.Middleware.LazyPreload
  alias UnterEatsWeb.Api.Middleware.RestrictAccess

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

  input_object :product_pagination_params do
    standard_pagination_params()
  end

  object :product_page do
    pagination_fields(:product)
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

    field :paginate_products, non_null(:product_page) do
      arg(:params, non_null(:product_pagination_params))
      middleware(RestrictAccess)
      resolve(&ProductResolvers.paginate_products/2)
      middleware(GraphQLTools.FormatPage)
    end
  end
end
