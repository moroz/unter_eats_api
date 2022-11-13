defmodule UnterEatsWeb.Api.Types.Images do
  use Absinthe.Schema.Notation
  alias UnterEatsWeb.Api.Middleware.RestrictAccess
  alias UnterEatsWeb.Api.Resolvers.ImageResolvers

  object :image_mutations do
    field :upload_product_image, non_null(:product_mutation_result) do
      arg(:product_id, non_null(:id))
      arg(:image, non_null(:upload))

      middleware(RestrictAccess)
      resolve(&ImageResolvers.upload_product_image/2)
    end
  end
end
