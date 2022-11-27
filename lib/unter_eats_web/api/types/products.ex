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
    field :in_stock, non_null(:boolean)

    field :image_uuid, :id do
      resolve_with_batch(UnterEats.Images, :batch_load_product_image_uuids)
    end

    field :categories, non_null(list_of(non_null(:category))) do
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

  input_object :create_product_params do
    field :name_pl, non_null(:string)
    field :name_en, :string
    field :description_pl, :string
    field :description_en, :string
    field :price, non_null(:decimal)
    field :slug, :string
    field :in_stock, :boolean
  end

  input_object :update_product_params do
    field :name_pl, :string
    field :name_en, :string
    field :description_pl, :string
    field :description_en, :string
    field :price, :decimal
    field :slug, :string
    field :in_stock, :boolean
  end

  object :product_mutation_result do
    mutation_result_fields(:product)
  end

  object :product_mutations do
    field :create_product, non_null(:product_mutation_result) do
      arg(:params, non_null(:create_product_params))
      middleware(RestrictAccess)
      resolve(&ProductResolvers.create_product/2)
    end

    field :update_product, non_null(:product_mutation_result) do
      arg(:id, non_null(:id))
      arg(:params, non_null(:update_product_params))
      middleware(RestrictAccess)
      resolve(&ProductResolvers.update_product/2)
    end

    field :delete_product, non_null(:product_mutation_result) do
      arg(:id, non_null(:id))
      middleware(RestrictAccess)
      resolve(&ProductResolvers.delete_product/2)
    end

    field :toggle_product_in_stock, non_null(:product_mutation_result) do
      arg(:id, non_null(:id))
      arg(:in_stock, :boolean)
      middleware(RestrictAccess)
      resolve(&ProductResolvers.toggle_product_in_stock/2)
    end
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
