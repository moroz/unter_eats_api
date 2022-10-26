defmodule UnterEats.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name_pl, :string
      add :name_en, :string, null: false
      add :slug, :string, null: false
      add :price, :decimal
      add :description_pl, :text
      add :description_en, :text

      timestamps()
    end

    create unique_index(:products, [:slug])
  end
end
