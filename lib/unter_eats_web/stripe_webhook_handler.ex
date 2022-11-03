defmodule UnterEatsWeb.StripeWebhookHandler do
  @behaviour Stripe.WebhookHandler

  import Logger
  import ShorterMaps

  def handle_event(%Stripe.Event{type: "payment_intent.succeeded"} = event) do
    handle_payment_intent(event.data.object)
  end

  def handle_event(_), do: :ok

  defp handle_payment_intent(%Stripe.PaymentIntent{
         amount: amount,
         amount_received: amount,
         metadata: ~m{order_id},
         id: id
       }) do
    info("Received payment notification for PaymentIntent #{id}, order id #{order_id}")
    :ok
  end

  defp handle_payment_intent(%Stripe.PaymentIntent{id: id}) do
    error("Received payment notification for unrecognized PaymentIntent #{id}")
    :ok
  end
end
