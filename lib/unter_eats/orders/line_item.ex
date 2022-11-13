defmodule UnterEats.Orders.LineItem do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "line_items" do
    field :quantity, :integer
    field :product_name, :string
    field :product_price, :decimal
    belongs_to :product, UnterEats.Products.Product
    belongs_to :order, UnterEats.Orders.Order

    timestamps()
  end

  @doc false
  def changeset(line_item, attrs) do
    line_item
    |> cast(attrs, [:quantity, :product_id, :order_id])
    |> validate_required([:quantity, :product_id])
  end
end
