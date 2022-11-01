defmodule UnterEats.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :grand_total, :decimal
      add :full_name, :string
      add :email, :string
      add :shipping_address, :text

      timestamps()
    end
  end
end
