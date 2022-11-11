defmodule UnterEats.Categories.Category do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.SlugHelpers

  schema "categories" do
    field :name_en, :string
    field :name_pl, :string
    field :slug, :string

    has_many :products_categories, UnterEats.Products.ProductCategory
    has_many :products, through: [:products_categories, :product]

    timestamps()
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name_pl, :name_en, :slug])
    |> SlugHelpers.maybe_set_slug()
    |> validate_required([:name_pl, :name_en, :slug])
    |> unique_constraint(:slug)
  end
end
