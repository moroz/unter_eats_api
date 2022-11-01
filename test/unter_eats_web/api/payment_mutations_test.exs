defmodule UnterEatsWeb.Api.PaymentMutationsTest do
  use UnterEatsWeb.GraphQLCase

  @mutation """
  query CreatePaymentIntent($amount: Int!) {
    createPaymentIntent(amount: $amount) {
      token
    }
  }
  """
end
