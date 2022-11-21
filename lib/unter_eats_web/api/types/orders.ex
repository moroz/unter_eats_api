defmodule UnterEatsWeb.Api.Types.Orders do
  use Absinthe.Schema.Notation
  import UnterEatsWeb.Api.Middleware.LazyPreload
  alias UnterEatsWeb.Api.Middleware.RestrictAccess
  import GraphQLTools.SchemaHelpers
  alias UnterEatsWeb.Api.Resolvers.OrderResolvers
  alias UnterEats.Orders.Order

  enum :delivery_type do
    value(:delivery)
    value(:pickup)
  end

  object :order do
    field :id, non_null(:id)
    field :email, non_null(:string)
    field :grand_total, non_null(:decimal)
    field :shipping_address, :string

    field :line_items, non_null(list_of(non_null(:line_item))) do
      lazy_preload()
    end

    field :first_name, non_null(:string)
    field :phone_no, non_null(:string)
    field :last_name, :string
    field :delivery_type, non_null(:delivery_type)
    field :paid_at, :datetime
    field :fulfilled_at, :datetime
    field :payment_method, :string
    field :metadata, :json

    field :payment_intent, :payment_intent do
      resolve(&OrderResolvers.resolve_payment_intent/3)
    end
  end

  input_object :order_params do
    field :email, non_null(:string)
    field :first_name, non_null(:string)
    field :last_name, :string
    field :remarks, :string
    field :delivery_type, non_null(:delivery_type)
    field :phone_no, non_null(:string)
    field :shipping_address, non_null(:string)
    field :line_items, non_null(list_of(non_null(:line_item_params)))
    field :metadata, :json
  end

  object :line_item do
    field :id, non_null(:id)
    field :order_id, non_null(:id)
    field :product_id, :id
    field :quantity, non_null(:integer)
    field :product_name, non_null(:string)
    field :product_price, :decimal

    field :product, :product do
      lazy_preload()
    end

    field :order, non_null(:order) do
      lazy_preload()
    end
  end

  input_object :line_item_params do
    field :product_id, non_null(:id)
    field :quantity, non_null(:integer)
  end

  object :order_mutation_result do
    mutation_result_fields(:order)
  end

  object :order_page do
    pagination_fields(:order)
  end

  input_object :order_pagination_params do
    standard_pagination_params()
  end

  object :order_mutations do
    field :create_order, non_null(:order_mutation_result) do
      arg(:params, non_null(:order_params))
      resolve(&OrderResolvers.create_order/2)
      middleware(UnterEatsWeb.Api.Middleware.StoreOrderIdInSession)
    end

    field :order_fulfilled, non_null(:order_mutation_result) do
      arg(:id, non_null(:id))
      middleware(RestrictAccess)
      resolve(&OrderResolvers.order_fulfilled/2)
    end
  end

  object :order_queries do
    field :incoming_orders, non_null(list_of(non_null(:order))) do
      middleware(RestrictAccess)
      resolve(&OrderResolvers.list_incoming_orders/2)
    end

    field :paginate_orders, non_null(:order_page) do
      arg(:params, non_null(:order_pagination_params))
      middleware(RestrictAccess)
      resolve(&OrderResolvers.paginate_orders/2)
      middleware(GraphQLTools.FormatPage)
    end
  end

  object :order_subscriptions do
    field :order_placed, non_null(:order) do
      config(fn _args ->
        {:ok, topic: "orders"}
      end)

      resolve(fn %Order{} = order, _, _ -> {:ok, order} end)
    end
  end
end
