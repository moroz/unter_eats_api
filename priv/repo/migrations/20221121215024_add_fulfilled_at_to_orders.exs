defmodule UnterEats.Repo.Migrations.AddFulfilledAtToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :fulfilled_at, :naive_datetime
    end

    execute "alter table orders add constraint orders_must_be_paid_to_be_fulfilled check (fulfilled_at is null or (fulfilled_at is not null and paid_at is not null));"
  end

  def down do
    execute "alter table orders drop constraint orders_must_be_paid_to_be_fulfilled;"

    alter table(:orders) do
      remove :fulfilled_at, :naive_datetime
    end
  end
end
