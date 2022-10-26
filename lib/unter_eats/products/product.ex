defmodule UnterEats.Products.Product do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "products" do
    field :description_en, :string
    field :description_pl, :string
    field :name_en, :string
    field :name_pl, :string
    field :price, :decimal
    field :slug, :string

    has_many :products_categories, UnterEats.Products.ProductCategory
    has_many :categories, through: [:products_categories, :category]

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name_pl, :name_en, :slug, :price, :description_pl, :description_en])
    |> validate_required([:name_pl, :name_en, :slug, :price, :description_pl, :description_en])
  end
end
