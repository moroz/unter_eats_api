defmodule UnterEats.Repo.Migrations.AddNullOnProductIdInLineItems do
  use Ecto.Migration

  def up do
    alter table(:line_items) do
      modify :product_id, :uuid, null: true
    end
  end

  def down do
    alter table(:line_items) do
      modify :product_id, :uuid, null: false
    end
  end
end
