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

  describe "line_items" do
    alias UnterEats.Orders.LineItem

    import UnterEats.OrdersFixtures

    @invalid_attrs %{quantity: nil}

    test "list_line_items/0 returns all line_items" do
      line_item = line_item_fixture()
      assert Orders.list_line_items() == [line_item]
    end

    test "get_line_item!/1 returns the line_item with given id" do
      line_item = line_item_fixture()
      assert Orders.get_line_item!(line_item.id) == line_item
    end

    test "create_line_item/1 with valid data creates a line_item" do
      valid_attrs = %{quantity: 42}

      assert {:ok, %LineItem{} = line_item} = Orders.create_line_item(valid_attrs)
      assert line_item.quantity == 42
    end

    test "create_line_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Orders.create_line_item(@invalid_attrs)
    end

    test "update_line_item/2 with valid data updates the line_item" do
      line_item = line_item_fixture()
      update_attrs = %{quantity: 43}

      assert {:ok, %LineItem{} = line_item} = Orders.update_line_item(line_item, update_attrs)
      assert line_item.quantity == 43
    end

    test "update_line_item/2 with invalid data returns error changeset" do
      line_item = line_item_fixture()
      assert {:error, %Ecto.Changeset{}} = Orders.update_line_item(line_item, @invalid_attrs)
      assert line_item == Orders.get_line_item!(line_item.id)
    end

    test "delete_line_item/1 deletes the line_item" do
      line_item = line_item_fixture()
      assert {:ok, %LineItem{}} = Orders.delete_line_item(line_item)
      assert_raise Ecto.NoResultsError, fn -> Orders.get_line_item!(line_item.id) end
    end

    test "change_line_item/1 returns a line_item changeset" do
      line_item = line_item_fixture()
      assert %Ecto.Changeset{} = Orders.change_line_item(line_item)
    end
  end
end
