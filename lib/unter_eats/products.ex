defmodule UnterEats.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias UnterEats.Repo

  alias UnterEats.Products.Product

  def list_products do
    Repo.all(Product)
  end

  def base_query do
    Product
    |> order_by(:name_pl)
  end

  def filter_and_paginate_products(params \\ %{}) do
    base_query()
    |> filter_by_params(params)
    |> Repo.paginate(params)
  end

  defp filter_by_params(query, params) do
    Enum.reduce(params, query, &do_filter_by_params/2)
  end

  defp do_filter_by_params(_, query), do: query

  def get_product!(id), do: Repo.get!(Product, id)

  def get_product_by_slug(slug) when is_binary(slug) do
    Repo.get_by(Product, slug: slug)
  end

  def get_products_by_ids(ids) when is_list(ids) do
    Product
    |> where([p], p.id in ^ids)
    |> Repo.all()
  end

  def get_price_mappings(product_ids) do
    Product
    |> where([p], p.id in ^product_ids)
    |> select([p], {p.id, p.price})
    |> Repo.all()
    |> Map.new()
  end

  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end
end
