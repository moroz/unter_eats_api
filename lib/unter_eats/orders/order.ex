defmodule UnterEats.Orders.Order do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.Products
  alias UnterEats.Orders.LineItem
  import EctoEnum

  defenum(DeliveryType, :delivery_type, [:delivery, :pickup])

  schema "orders" do
    field :email, :string
    field :phone_no, :string
    field :first_name, :string
    field :last_name, :string
    field :remarks, :string
    field :delivery_type, DeliveryType
    field :grand_total, :decimal
    field :shipping_address, :string
    field :paid_at, :utc_datetime
    has_many :line_items, LineItem
    has_many :payment_intents, UnterEats.Payments.PaymentIntent

    timestamps()
  end

  @required ~w(first_name email delivery_type phone_no)a
  @cast @required ++ ~w(last_name remarks shipping_address paid_at)a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @cast)
    |> validate_required(@required)
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
