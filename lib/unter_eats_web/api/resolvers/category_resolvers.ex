defmodule UnterEatsWeb.Api.Resolvers.CategoryResolvers do
  alias UnterEats.Categories

  def get_category(%{id: id}, _) do
    {:ok, Categories.get_category_by_slug_or_id!(id)}
  end

  def list_categories(_, _) do
    {:ok, Categories.list_categories()}
  end
end
