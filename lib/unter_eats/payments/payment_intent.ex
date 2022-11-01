defmodule UnterEats.Payments.PaymentIntent do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "payment_intents" do
    field :stripe_id, :string
    belongs_to :order, UnterEats.Orders.Order
    field :client_secret, :string, virtual: true

    timestamps()
  end

  @doc false
  def changeset(payment_intent, attrs) do
    payment_intent
    |> cast(attrs, [:stripe_id, :order_id, :client_secret])
    |> validate_required([:stripe_id, :order_id])
  end
end
