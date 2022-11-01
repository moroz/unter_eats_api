defmodule UnterEats.Orders.Order do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "orders" do
    field :email, :string
    field :full_name, :string
    field :grand_total, :decimal
    field :shipping_address, :string

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:grand_total, :full_name, :email, :shipping_address])
    |> validate_required([:grand_total, :full_name, :email, :shipping_address])
  end
end
