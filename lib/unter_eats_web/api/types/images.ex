defmodule UnterEatsWeb.Api.Types.Images do
  use Absinthe.Schema.Notation

  object :image_mutations do
    field :id, non_null(:id)
    field :product_id, non_null(:product_id)
  end
end
