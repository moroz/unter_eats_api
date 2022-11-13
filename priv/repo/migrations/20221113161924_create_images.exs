defmodule UnterEats.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :product_id, references(:products, on_delete: :delete_all), null: false

      timestamps()
    end

    create unique_index(:images, [:product_id])
  end
end
