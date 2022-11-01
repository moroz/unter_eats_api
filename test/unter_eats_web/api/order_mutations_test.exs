defmodule UnterEatsWeb.Api.OrderMutationsTest do
  use UnterEatsWeb.GraphQLCase
  alias UnterEats.Orders.Order

  @mutation """
  mutation CreateOrder($params: OrderParams!) {
    result: createOrder(params: $params) {
      success
      errors {
        key
        message
      }
      data {
        id
        grandTotal
        email
        paymentIntent {
          orderId
          stripeId
          clientSecret
        }
      }
    }
  }
  """

  setup do
    lamburchili = insert(:product, name_pl: "Lamburchili", price: "21", slug: "lamburchili")
    dal = insert(:product, name_pl: "Dal tarkari", price: "37", slug: "dal")

    ~M{lamburchili, dal}
  end

  describe "createOrder mutation" do
    test "creates order with correct total and a payment intent", ~M{lamburchili, dal} do
      params = %{
        full_name: "Jan Nowak",
        email: "nowak@poczta.onet.pl",
        shipping_address: "ul. Nowogrodzka 84/86",
        line_items: [
          %{product_id: lamburchili.id, quantity: 3},
          %{product_id: dal.id, quantity: 2}
        ]
      }

      vars = %{params: params}
      %{data: %{"result" => %{"success" => true, "data" => actual}}} = mutate(@mutation, vars)
      order = Repo.get!(Order, actual["id"])
      assert order.grand_total == Decimal.new(137)
      assert order.email == params.email
      assert order.shipping_address == params.shipping_address
      assert order.full_name == params.full_name

      pi = actual["paymentIntent"]
      assert "pi_" <> _ = pi["stripeId"]
      assert "pi_" <> _ = pi["clientSecret"]
      refute pi["clientSecret"] == pi["stripeId"]
      assert pi["orderId"] == order.id
    end
  end
end
