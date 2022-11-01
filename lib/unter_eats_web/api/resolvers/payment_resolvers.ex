defmodule UnterEatsWeb.Api.Resolvers.PaymentResolvers do
  import ShorterMaps

  def create_payment_intent(~M{amount}, _) do
    Stripe.PaymentIntent.create(%{
      amount: amount,
      currency: "PLN",
      automatic_payment_methods: %{enabled: true}
    })
  end
end
