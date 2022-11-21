defmodule UnterEatsWeb.Api.OrderMutationsTest do
  use UnterEatsWeb.GraphQLCase
  alias UnterEats.Orders.Order
  alias UnterEats.Store

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
    Store.open_store()

    ~M{lamburchili, dal}
  end

  describe "createOrder mutation" do
    test "creates order with correct total and a payment intent", ~M{lamburchili, dal} do
      params = %{
        first_name: "Jan",
        last_name: "Nowak",
        delivery_type: :delivery,
        email: "nowak@poczta.onet.pl",
        phone_no: "+48555123456",
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
      assert order.first_name == params.first_name
      assert order.last_name == params.last_name

      pi = actual["paymentIntent"]
      assert "pi_" <> _ = pi["stripeId"]
      assert "pi_" <> _ = pi["clientSecret"]
      refute pi["clientSecret"] == pi["stripeId"]
      assert pi["orderId"] == order.id
    end
  end

  @mutation """
  mutation OrderFulfilled($id: ID!) {
    result: orderFulfilled(id: $id) {
      success
      errors {
        key
        message
      }
      data {
        id
        paidAt
        fulfilledAt
      }
    }
  }
  """

  describe "orderFulfilled mutation" do
    setup do
      [user: insert(:user)]
    end

    test "denies access when called unauthenticated" do
      order = build(:order) |> paid() |> insert()

      vars = %{id: order.id}

      %{data: %{"result" => %{"success" => false, "errors" => [error]}}} = mutate(@mutation, vars)

      assert error["message"] =~ "authenticate"
    end

    test "returns error when called with unpaid order", ~M{user} do
      vars = %{id: insert(:order).id}

      %{"result" => %{"success" => false, "errors" => [errors]}} =
        mutate_with_user(@mutation, user, vars)

      assert errors["message"] =~ "paid"
    end

    test "returns error when called with fulfilled order", ~M{user} do
      order = build(:order) |> paid() |> fulfilled() |> insert()
      vars = %{id: order.id}

      %{"result" => %{"success" => false, "errors" => [errors]}} =
        mutate_with_user(@mutation, user, vars)

      assert errors["message"] =~ "fulfilled"
    end

    test "marks order as fulfilled when called with valid params", ~M{user} do
      order = build(:order) |> paid() |> insert()
      vars = %{id: order.id}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert {:ok, %DateTime{}, 0} = DateTime.from_iso8601(actual["fulfilledAt"])
    end
  end
end
