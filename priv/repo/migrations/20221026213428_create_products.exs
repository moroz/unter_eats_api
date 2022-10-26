defmodule UnterEats.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name_pl, :string, null: false
      add :name_en, :string
      add :slug, :string, null: false
      add :price, :decimal
      add :description_pl, :text
      add :description_en, :text

      timestamps()
    end

    create unique_index(:products, [:slug])
  end
end
