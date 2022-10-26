defmodule UnterEats.Repo.Migrations.CreateProductsCategories do
  use Ecto.Migration

  def change do
    create table(:products_categories, primary_key: false) do
      add :product_id, references(:products, on_delete: :nothing), null: false
      add :category_id, references(:categories, on_delete: :nothing), null: false

      timestamps(updated_at: false)
    end

    create unique_index(:products_categories, [:product_id, :category_id])
  end
end
