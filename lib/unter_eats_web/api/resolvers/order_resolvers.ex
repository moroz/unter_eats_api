defmodule UnterEatsWeb.Api.Resolvers.OrderResolvers do
  alias UnterEats.Orders
  alias UnterEats.Payments
  import ShorterMaps

  def create_order(~M{params}, _) do
    Orders.create_order(params)
  end

  def resolve_payment_intent(order, _, _) do
    {:ok, Payments.get_or_create_order_payment_intent(order)}
  end
end
