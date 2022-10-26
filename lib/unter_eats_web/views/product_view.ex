defmodule UnterEatsWeb.ProductView do
  use UnterEatsWeb, :view
  alias UnterEatsWeb.ProductView

  def render("index.json", %{products: products}) do
    %{data: render_many(products, ProductView, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{data: render_one(product, ProductView, "product.json")}
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      name_pl: product.name_pl,
      name_en: product.name_en,
      slug: product.slug,
      price: product.price,
      description_pl: product.description_pl,
      description_en: product.description_en
    }
  end
end
