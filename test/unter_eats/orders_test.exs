defmodule UnterEats.OrdersTest do
  use UnterEats.DataCase

  alias UnterEats.Orders

  describe "orders" do
    alias UnterEats.Orders.Order

    import UnterEats.OrdersFixtures

    @invalid_attrs %{email: nil, full_name: nil, grand_total: nil, shipping_address: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Orders.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Orders.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{email: "some email", full_name: "some full_name", grand_total: "120.5", shipping_address: "some shipping_address"}

      assert {:ok, %Order{} = order} = Orders.create_order(valid_attrs)
      assert order.email == "some email"
      assert order.full_name == "some full_name"
      assert order.grand_total == Decimal.new("120.5")
      assert order.shipping_address == "some shipping_address"
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{email: "some updated email", full_name: "some updated full_name", grand_total: "456.7", shipping_address: "some updated shipping_address"}

      assert {:ok, %Order{} = order} = Orders.update_order(order, update_attrs)
      assert order.email == "some updated email"
      assert order.full_name == "some updated full_name"
      assert order.grand_total == Decimal.new("456.7")
      assert order.shipping_address == "some updated shipping_address"
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_order(order, @invalid_attrs)
      assert order == Orders.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Orders.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Orders.change_order(order)
    end
  end
end
