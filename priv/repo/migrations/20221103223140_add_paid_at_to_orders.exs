defmodule UnterEats.Repo.Migrations.AddPaidAtToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :paid_at, :timestamp
    end
  end
end
