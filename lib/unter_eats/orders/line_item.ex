defmodule UnterEats.Orders.LineItem do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.Products

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
    |> foreign_key_constraint(:product_id)
    |> set_product_attributes()
  end

  defp set_product_attributes(changeset) do
    product_id = get_field(changeset, :product_id)
    product = Products.get_product!(product_id)

    changeset
    |> put_change(:product_name, product.name_pl)
    |> put_change(:product_price, product.price)
  end
end
