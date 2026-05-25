defmodule UnterEatsWeb.Api.OrderMutationsTest do
  use UnterEatsWeb.GraphQLCase
  import Mock
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
    lamburchili = build(:product, price: 21) |> with_name("Lamburchili") |> insert()
    dal = build(:product, price: 37) |> with_name("Dal tarkari") |> insert()
    Store.open_store()

    %{lamburchili: lamburchili, dal: dal}
  end

  describe "createOrder mutation" do
    test "creates order with correct total and a payment intent", %{
      lamburchili: lamburchili,
      dal: dal
    } do
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
        ],
        metadata:
          Jason.encode!(%{
            viewport_width: 375,
            viewport_height: 800
          })
      }

      vars = %{params: params}

      stripe_id = "pi_test_" <> Base.encode16(:crypto.strong_rand_bytes(8), case: :lower)
      client_secret = stripe_id <> "_secret_" <> Base.encode16(:crypto.strong_rand_bytes(8), case: :lower)

      mock_intent = %Stripe.PaymentIntent{id: stripe_id, client_secret: client_secret}

      with_mock Stripe.PaymentIntent, create: fn _params -> {:ok, mock_intent} end do
        %{data: %{"result" => %{"success" => true, "data" => actual}}} = mutate(@mutation, vars)
        order = Repo.get!(Order, actual["id"])
        assert order.grand_total == Decimal.new(137)
        assert order.email == params.email
        assert order.shipping_address == params.shipping_address
        assert order.first_name == params.first_name
        assert order.last_name == params.last_name
        assert order.metadata["viewport_width"]

        pi = actual["paymentIntent"]
        assert pi["stripeId"] == stripe_id
        assert pi["clientSecret"] == client_secret
        assert pi["orderId"] == order.id

        assert_called(Stripe.PaymentIntent.create(:_))
      end
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

    test "returns error when called with unpaid order", %{user: user} do
      vars = %{id: insert(:order).id}

      %{"result" => %{"success" => false, "errors" => [errors]}} =
        mutate_with_user(@mutation, user, vars)

      assert errors["message"] =~ "paid"
    end

    test "returns error when called with fulfilled order", %{user: user} do
      order = build(:order) |> paid() |> fulfilled() |> insert()
      vars = %{id: order.id}

      %{"result" => %{"success" => false, "errors" => [errors]}} =
        mutate_with_user(@mutation, user, vars)

      assert errors["message"] =~ "fulfilled"
    end

    test "marks order as fulfilled when called with valid params", %{user: user} do
      order = build(:order) |> paid() |> insert()
      vars = %{id: order.id}

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, vars)

      assert {:ok, %DateTime{}, 0} = DateTime.from_iso8601(actual["fulfilledAt"])
    end
  end
end
