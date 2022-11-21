defmodule UnterEats.OrdersTest do
  use UnterEats.DataCase

  alias UnterEats.Orders
  alias UnterEats.Store

  describe "orders" do
    setup do
      lamburchili = insert(:product, name_pl: "Lamburchili", price: "21", slug: "lamburchili")
      dal = insert(:product, name_pl: "Dal tarkari", price: "37", slug: "dal")

      ~M{lamburchili, dal}
    end

    test "creates order with valid params", ~M{lamburchili, dal} do
      Store.open_store()

      params = %{
        first_name: "Jan",
        last_name: "Nowak",
        delivery_type: :delivery,
        email: "nowak@poczta.onet.pl",
        phone_no: "555123456",
        shipping_address: "ul. Nowogrodzka 84/86",
        line_items: [
          %{product_id: lamburchili.id, quantity: 3},
          %{product_id: dal.id, quantity: 2}
        ]
      }

      assert {:ok, order} = Orders.create_order(params)
      expected_total = Decimal.add(Decimal.mult(lamburchili.price, 3), Decimal.mult(dal.price, 2))
      assert order.grand_total == expected_total
      assert order.phone_no == "+48555123456"
    end
  end
end
