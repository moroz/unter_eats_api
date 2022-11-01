defmodule UnterEatsWeb.Api.Types.Orders do
  use Absinthe.Schema.Notation
  import UnterEatsWeb.Api.Middleware.LazyPreload
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.OrderResolvers

  object :order do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :grand_total, non_null(:decimal)
    field :shipping_address, :string
    field :line_items, non_null(list_of(non_null(:line_item)))

    field :payment_intent, :payment_intent do
      resolve(&OrderResolvers.resolve_payment_intent/3)
    end
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

  object :order_mutation_result do
    mutation_result_fields(:order)
  end

  input_object :line_item_params do
    field :product_id, non_null(:id)
    field :quantity, non_null(:integer)
  end

  input_object :order_params do
    field :email, non_null(:string)
    field :full_name, non_null(:string)
    field :shipping_address, non_null(:string)
    field :line_items, non_null(list_of(non_null(:line_item_params)))
  end

  object :order_mutations do
    field :create_order, non_null(:order_mutation_result) do
      arg(:params, :order_params)
      resolve(&OrderResolvers.create_order/2)
    end
  end
end
