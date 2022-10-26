defmodule UnterEats.Products.ProductCategory do
  use UnterEats.Schema
  import Ecto.Changeset

  @primary_key false
  schema "products_categories" do
    belongs_to :product, UnterEats.Products.Product, primary_key: true
    belongs_to :category, UnterEats.Categories.Category, primary_key: true

    timestamps(updated_at: false)
  end

  @doc false
  def changeset(product_category, attrs) do
    product_category
    |> cast(attrs, [])
    |> validate_required([])
  end
end
