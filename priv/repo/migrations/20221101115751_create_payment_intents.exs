defmodule UnterEats.Repo.Migrations.CreatePaymentIntents do
  use Ecto.Migration

  def change do
    create table(:payment_intents) do
      add :stripe_id, :string, null: false
      add :order_id, references(:orders, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:payment_intents, [:order_id])
  end
end
