defmodule UnterEats.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :name_pl, :string
      add :name_en, :string, null: false
      add :slug, :string, null: false

      timestamps()
    end

    create unique_index(:categories, [:slug])
  end
end
