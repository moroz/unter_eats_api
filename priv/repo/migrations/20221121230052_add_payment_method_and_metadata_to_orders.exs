defmodule UnterEats.Repo.Migrations.AddPaymentMethodAndMetadataToOrders do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :payment_method, :string
      add :metadata, :jsonb
    end
  end
end
