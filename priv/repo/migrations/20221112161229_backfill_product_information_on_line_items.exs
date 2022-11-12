defmodule UnterEats.Repo.Migrations.BackfillProductInformationOnLineItems do
  use Ecto.Migration

  @moduledoc """
  Store a product's name and unit price on line items, so that when a product
  is updated or deleted in the future, the name and price still reflect the
  data at the point in time when the order was placed.
  """

  def up do
    alter table(:line_items) do
      add :product_name, :string
      add :product_price, :decimal
    end

    execute """
    update line_items li
    set product_name = p.name_pl, product_price = p.price
    from products p
    where p.id = li.product_id
    """

    alter table(:line_items) do
      modify :product_name, :string, null: false
    end
  end

  def down do
    alter table(:line_items) do
      remove :product_name
      remove :product_price
    end
  end
end
