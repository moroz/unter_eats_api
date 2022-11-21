defmodule UnterEatsWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  import Logger
  import ShorterMaps
  alias Stripe.PaymentMethod
  alias UnterEats.Orders

  def handle_event(%Stripe.Event{type: "payment_intent.succeeded"} = event) do
    handle_payment_intent(event.data.object)
  end

  def handle_event(_), do: :ok

  defp handle_payment_intent(%Stripe.PaymentIntent{
         amount: amount,
         amount_received: amount,
         metadata: ~m{order_id},
         id: id,
         payment_method: method
       }) do
    info("Received payment notification for PaymentIntent #{id}, order id #{order_id}")
    payment_method = get_payment_method(method)
    order = Orders.get_order!(order_id)
    Orders.mark_order_as_paid(order, payment_method)
  end

  defp handle_payment_intent(%Stripe.PaymentIntent{id: id}) do
    error("Received payment notification for unrecognized PaymentIntent #{id}")
    :ok
  end

  defp get_payment_method(id) when is_binary(id) do
    case Stripe.PaymentMethod.retrieve(id) do
      {:ok, %PaymentMethod{} = method} ->
        method.type

      _ ->
        nil
    end
  end
end
