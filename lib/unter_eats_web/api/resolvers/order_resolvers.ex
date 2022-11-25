defmodule UnterEatsWeb.Api.Resolvers.OrderResolvers do
  alias UnterEats.Orders
  alias UnterEats.Payments
  import ShorterMaps

  def get_order(~M{id}, _) do
    {:ok, Orders.get_order!(id)}
  end

  def create_order(~M{params}, _) do
    Orders.create_order(params)
  end

  def order_fulfilled(~M{id}, _) do
    order = Orders.get_order!(id)

    case Orders.mark_order_as_fulfilled(order) do
      {:error, :already_fulfilled} ->
        {:error, "This order has already been fulfilled."}

      {:error, :not_paid} ->
        {:error, "Only paid orders can be marked as fulfilled."}

      other ->
        other
    end
  end

  def list_incoming_orders(_, _) do
    {:ok, Orders.list_incoming_orders()}
  end

  def resolve_payment_intent(order, _, _) do
    {:ok, Payments.get_or_create_order_payment_intent(order)}
  end

  def paginate_orders(~M{params}, _) do
    {:ok, Orders.filter_and_paginate_orders(params)}
  end
end
