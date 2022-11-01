defmodule UnterEats.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :grand_total, :decimal, null: false, default: 0
      add :full_name, :string
      add :email, :string, null: false
      add :shipping_address, :text

      timestamps()
    end
  end
end
