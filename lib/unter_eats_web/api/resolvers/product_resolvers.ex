defmodule UnterEatsWeb.Api.Resolvers.ProductResolvers do
  alias UnterEats.Products

  def toggle_product_in_stock(%{id: id} = params, _) do
    in_stock = Map.get(params, :in_stock, nil)
    product = Products.get_product!(id)
    Products.toggle_product_in_stock(product, in_stock)
  end

  def get_product(%{id: id}, _) do
    {:ok, Products.get_product!(id)}
  end

  def list_products(%{ids: ids}, _) do
    {:ok, Products.get_products_by_ids(ids)}
  end

  def paginate_products(%{params: params}, _) do
    {:ok, Products.filter_and_paginate_products(params)}
  end

  def create_product(%{params: params}, _) do
    Products.create_product(params)
  end

  def update_product(%{id: id, params: params}, _) do
    product = Products.get_product!(id)
    Products.update_product(product, params)
  end

  def delete_product(%{id: id}, _) do
    product = Products.get_product!(id)
    Products.delete_product(product)
  end
end
