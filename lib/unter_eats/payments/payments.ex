defmodule UnterEats.Payments do
  alias UnterEats.Repo
  alias UnterEats.Orders.Order
  alias UnterEats.Payments.PaymentIntent
  import Ecto.Query

  def create_payment_intent_for_order(%Order{} = order) do
    with {:ok, payment_intent} <- create_stripe_payment_intent_for(order) do
      {:ok, intent} =
        create_payment_intent(%{
          order_id: order.id,
          stripe_id: payment_intent.id,
          client_secret: payment_intent.client_secret
        })

      intent
    end
  end

  def get_or_create_order_payment_intent(%Order{} = order) do
    get_order_last_payment_intent(order) || create_payment_intent_for_order(order)
  end

  def get_order_last_payment_intent(%Order{} = order) do
    order
    |> Ecto.assoc(:payment_intents)
    |> order_by(:inserted_at)
    |> last()
    |> Repo.one()
  end

  def create_payment_intent(attrs) do
    %PaymentIntent{}
    |> PaymentIntent.changeset(attrs)
    |> Repo.insert()
  end

  defp create_stripe_payment_intent_for(%Order{} = order) do
    amount = Decimal.mult(order.grand_total, 100) |> Decimal.to_integer()

    Stripe.PaymentIntent.create(%{
      currency: "PLN",
      amount: amount,
      payment_method_types: ["blik", "card", "p24"],
      metadata: %{
        order_id: order.id
      }
    })
  end
end
