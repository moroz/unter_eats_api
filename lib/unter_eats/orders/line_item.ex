defmodule UnterEats.Orders.LineItem do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "line_items" do
    field :quantity, :integer
    field :order_id, :id
    field :product_id, :id

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
