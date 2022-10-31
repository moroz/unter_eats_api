defmodule UnterEatsWeb.Api.Resolvers.PaymentResolvers do
  import ShorterMaps

  def create_payment_intent(~M{amount}, _) do
    with {:ok, payment_intent} <- Stripe.PaymentIntent.create(%{amount: amount, currency: "PLN"}) do
      {:ok, %{data: payment_intent}}
    end
  end
end
