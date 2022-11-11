defmodule UnterEatsWeb.Api.Resolvers.ProductResolvers do
  alias UnterEats.Products
  import ShorterMaps

  def get_product(~M{id}, _) do
    {:ok, Products.get_product!(id)}
  end

  def list_products(~M{ids}, _) do
    {:ok, Products.get_products_by_ids(ids)}
  end

  def paginate_products(~M{params}, _) do
    {:ok, Products.filter_and_paginate_products(params)}
  end
end
