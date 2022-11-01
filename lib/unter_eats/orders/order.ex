defmodule UnterEats.Orders.Order do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.Products
  alias UnterEats.Orders.LineItem

  schema "orders" do
    field :email, :string
    field :full_name, :string
    field :grand_total, :decimal
    field :shipping_address, :string
    has_many :line_items, LineItem
    has_many :payment_intents, UnterEats.Payments.PaymentIntent

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:full_name, :email, :shipping_address])
    |> validate_required([:full_name, :email, :shipping_address])
    |> cast_assoc(:line_items, with: &LineItem.changeset/2)
    |> set_grand_total()
  end

  defp set_grand_total(changeset) do
    case get_change(changeset, :line_items) do
      line_items when is_list(line_items) ->
        subtotal = calculate_total(line_items)
        put_change(changeset, :grand_total, subtotal)

      _ ->
        changeset
    end
  end

  defp transform_line_items(line_items) do
    for line_item <- line_items, into: %{} do
      product_id = get_field(line_item, :product_id)
      quantity = get_field(line_item, :quantity)
      {product_id, quantity}
    end
  end

  defp calculate_total(line_items) do
    transformed = transform_line_items(line_items)
    ids = Enum.map(transformed, &elem(&1, 0))
    price_mappings = Products.get_price_mappings(ids)

    Enum.reduce(transformed, Decimal.new(0), fn {product_id, quantity}, acc ->
      amount = Decimal.mult(price_mappings[product_id], quantity)
      Decimal.add(acc, amount)
    end)
  end
end
