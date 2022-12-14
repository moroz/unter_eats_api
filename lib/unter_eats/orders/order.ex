defmodule UnterEats.Orders.Order do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.Products
  alias UnterEats.Store
  alias UnterEats.Orders.LineItem
  import EctoEnum
  import Ecto.Query

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
    field :payment_method
    field :metadata, :map
    field :paid_at, :utc_datetime
    field :fulfilled_at, :utc_datetime
    field :shipping_fee, :decimal
    has_many :line_items, LineItem
    has_many :payment_intents, UnterEats.Payments.PaymentIntent

    timestamps()
  end

  @required ~w(first_name email delivery_type phone_no)a
  @cast @required ++ ~w(last_name remarks shipping_address metadata payment_method)a

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> UnterEats.PhoneValidator.validate_phone_number()
    |> EmailTldValidator.Ecto.validate_email()
    |> check_store_is_open()
    |> cast_assoc(:line_items, with: &LineItem.changeset/2)
    |> set_grand_total()
  end

  def update_changeset(order, attrs) do
    order
    |> cast(attrs, ~w(paid_at fulfilled_at)a)
    |> check_constraint(:fulfilled_at,
      name: "orders_must_be_paid_to_be_fulfilled",
      message: "only paid orders can be marked as fulfilled"
    )
  end

  def paid_orders(queryable) do
    queryable
    |> where([o], not is_nil(o.paid_at))
    |> where([o], is_nil(o.fulfilled_at))
  end

  def fulfilled_orders(queryable) do
    queryable
    |> where([o], not is_nil(o.paid_at) and not is_nil(o.fulfilled_at))
  end

  defp check_store_is_open(changeset) do
    case Store.is_store_open?() do
      false ->
        add_error(changeset, :email, "The restaurant is currently closed.")

      _ ->
        changeset
    end
  end

  defp set_grand_total(changeset) do
    case get_change(changeset, :line_items) do
      line_items when is_list(line_items) ->
        delivery_type = get_change(changeset, :delivery_type)
        subtotal = calculate_total(line_items)
        shipping_fee = calculate_shipping_fee(delivery_type, subtotal)
        grand_total = Decimal.add(subtotal, shipping_fee)

        changeset
        |> put_change(:grand_total, grand_total)
        |> put_change(:shipping_fee, shipping_fee)

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

  # TODO: Make this configurable
  @threshold 100
  @shipping_fee 15

  defp calculate_shipping_fee(:pickup, _), do: 0

  defp calculate_shipping_fee(_, subtotal) do
    if Decimal.lt?(subtotal, @threshold), do: @shipping_fee, else: 0
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
