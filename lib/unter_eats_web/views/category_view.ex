defmodule UnterEatsWeb.CategoryView do
  use UnterEatsWeb, :view
  alias UnterEatsWeb.CategoryView

  def render("index.json", %{categories: categories}) do
    %{data: render_many(categories, CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{data: render_one(category, CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name_pl: category.name_pl,
      name_en: category.name_en,
      slug: category.slug
    }
  end
end
