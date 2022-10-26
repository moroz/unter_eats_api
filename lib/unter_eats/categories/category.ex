defmodule UnterEats.Categories.Category do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "categories" do
    field :name_en, :string
    field :name_pl, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name_pl, :name_en, :slug])
    |> validate_required([:name_pl, :name_en, :slug])
    |> unique_constraint(:slug)
  end
end
