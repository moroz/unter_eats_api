defmodule UnterEatsWeb.Api.Types.OrderTypes do
  use Absinthe.Schema.Notation
  import UnterEatsWeb.Api.Middleware.LazyPreload

  object :order do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :grand_total, non_null(:decimal)
    field :shipping_address, :string
  end

  object :line_item do
    field :id, non_null(:id)
    field :order_id, non_null(:id)
    field :product_id, non_null(:id)
    field :quantity, non_null(:integer)

    field :product, non_null(:product) do
      lazy_preload()
    end

    field :order, non_null(:order) do
      lazy_preload()
    end
  end
end
