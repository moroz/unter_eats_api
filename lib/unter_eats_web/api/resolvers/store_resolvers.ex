defmodule UnterEatsWeb.Api.Resolvers.StoreResolvers do
  alias UnterEats.Store
  import ShorterMaps

  def is_store_open(_, _) do
    {:ok, Store.is_store_open?()}
  end

  def close_store(_, _) do
    with {:error, :not_open} <- Store.close_store() do
      {:error, "The restaurant is not open."}
    end
  end

  def open_store(_, _) do
    with {:error, :already_open} <- Store.open_store() do
      {:error, "The restaurant is already open."}
    end
  end

  def filter_and_paginate_business_logs(~M{params}, _) do
    {:ok, Store.filter_and_paginate_business_logs(params)}
  end
end
