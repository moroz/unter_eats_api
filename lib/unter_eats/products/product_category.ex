defmodule UnterEats.Products.ProductCategory do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "products_categories" do
    belongs_to :product, UnterEats.Products.Product
    belongs_to :category, UnterEats.Categories.Category

    timestamps()
  end

  @doc false
  def changeset(product_category, attrs) do
    product_category
    |> cast(attrs, [])
    |> validate_required([])
  end
end
