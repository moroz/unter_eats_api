defmodule UnterEatsWeb.Api.Resolvers.PaymentResolvers do
  alias UnterEats.Payments.PaymentIntent

  def get_client_secret(%PaymentIntent{client_secret: secret}, _, _) when is_binary(secret) do
    {:ok, secret}
  end

  def get_client_secret(%PaymentIntent{} = pi, _, _) do
    case Stripe.PaymentIntent.retrieve(pi.stripe_id, %{}) do
      {:ok, %Stripe.PaymentIntent{} = pi} ->
        {:ok, pi.client_secret}

      _ ->
        {:ok, nil}
    end
  end
end
