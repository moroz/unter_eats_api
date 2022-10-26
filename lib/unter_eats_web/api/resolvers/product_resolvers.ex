defmodule UnterEatsWeb.Api.Resolvers.ProductResolvers do
  alias UnterEats.Products
  import ShorterMaps

  def get_product(~M{id}, _) do
    {:ok, Products.get_product!(id)}
  end
end
