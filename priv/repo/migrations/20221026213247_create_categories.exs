defmodule UnterEats.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name_pl, :string, null: false
      add :name_en, :string
      add :slug, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:slug])
    create unique_index(:categories, [:name_pl])
  end
end
