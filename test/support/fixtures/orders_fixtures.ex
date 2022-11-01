defmodule UnterEats.OrdersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UnterEats.Orders` context.
  """

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        email: "some email",
        full_name: "some full_name",
        grand_total: "120.5",
        shipping_address: "some shipping_address"
      })
      |> UnterEats.Orders.create_order()

    order
  end
end
