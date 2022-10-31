defmodule UnterEatsWeb.Api.PaymentMutationsTest do
  use UnterEatsWeb.GraphQLCase

  @mutation """
  mutation CreatePaymentIntent($amount: Int!) {
    createPaymentIntent(amount: $amount) {
      data
    }
  }
  """
end
