defmodule UnterEatsWeb.Api.Resolvers.ProductResolvers do
  alias UnterEats.Products
  import ShorterMaps

  def toggle_product_in_stock(~M{id} = params, _) do
    in_stock = Map.get(params, :in_stock)
    product = Products.get_product!(id)
    Products.toggle_product_in_stock(product)
  end

  def get_product(~M{id}, _) do
    {:ok, Products.get_product!(id)}
  end

  def list_products(~M{ids}, _) do
    {:ok, Products.get_products_by_ids(ids)}
  end

  def paginate_products(~M{params}, _) do
    {:ok, Products.filter_and_paginate_products(params)}
  end

  def create_product(~M{params}, _) do
    Products.create_product(params)
  end

  def update_product(~M{id, params}, _) do
    product = Products.get_product!(id)
    Products.update_product(product, params)
  end

  def delete_product(~M{id}, _) do
    product = Products.get_product!(id)
    Products.delete_product(product)
  end
end
