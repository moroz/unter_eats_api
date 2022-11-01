defmodule UnterEats.Payments.PaymentIntent do
  use Ecto.Schema
  import Ecto.Changeset

  schema "payment_intents" do
    field :stripe_id, :string
    field :order_id, :id

    timestamps()
  end

  @doc false
  def changeset(payment_intent, attrs) do
    payment_intent
    |> cast(attrs, [:stripe_id])
    |> validate_required([:stripe_id])
  end
end
