defmodule UnterEatsWeb.Api.Types.Payments do
  use Absinthe.Schema.Notation
  alias UnterEatsWeb.Api.Resolvers.PaymentResolvers

  object :payment_intent do
    field :client_secret, non_null(:string)
  end

  object :payment_mutations do
    field :create_payment_intent, :payment_intent do
      arg(:amount, non_null(:integer))
      resolve(&PaymentResolvers.create_payment_intent/2)
    end
  end
end
