defmodule UnterEatsWeb.Api.Resolvers.CategoryResolvers do
  alias UnterEats.Categories
  import ShorterMaps

  def get_category(~M{id}, _) do
    {:ok, Categories.get_category_by_slug_or_id!(id)}
  end

  def list_categories(_, _) do
    {:ok,
     Categories.list_categories()
     |> Categories.preload_assocs()}
  end
end
