defmodule UnterEatsWeb.Api.Resolvers.CategoryResolvers do
  alias UnterEats.Categories
  import ShorterMaps
  alias UnterEats.Repo

  def get_category(~M{id}, _) do
    {:ok, Categories.get_category_by_slug_or_id!(id)}
  end
end
