defmodule UnterEatsWeb.Api.Types.Categories do
  use Absinthe.Schema.Notation
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.CategoryResolvers
  import UnterEatsWeb.Api.Middleware.LazyPreload

  object :category do
    field :id, non_null(:id)
    field :name_en, :string
    field :name_pl, non_null(:string)
    field :slug, non_null(:string)

    field :products, non_null(list_of(non_null(:product))) do
      lazy_preload()
    end

    timestamps()
  end

  object :category_queries do
    field :category, :category do
      arg(:id, non_null(:id))
      resolve(&CategoryResolvers.get_category/2)
    end
  end
end
