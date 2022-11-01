defmodule UnterEatsWeb.Api.Types.Payments do
  use Absinthe.Schema.Notation
  alias UnterEatsWeb.Api.Resolvers.PaymentResolvers

  object :payment_intent do
    field :order_id, non_null(:id)
    field :stripe_id, non_null(:string)

    field :client_secret, non_null(:string) do
      resolve(&PaymentResolvers.get_client_secret/3)
    end
  end
end
