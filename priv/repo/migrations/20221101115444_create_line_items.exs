defmodule UnterEats.Repo.Migrations.CreateLineItems do
  use Ecto.Migration

  def change do
    create table(:line_items) do
      add :quantity, :integer, null: false
      add :order_id, references(:orders, on_delete: :nothing), null: false
      add :product_id, references(:products, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:line_items, [:order_id])
    create index(:line_items, [:product_id])
  end
end
