defmodule UnterEats.Repo.Migrations.AddInStockToProducts do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :in_stock, :boolean, null: false, default: true
    end
  end
end
