defmodule UnterEats.Orders do
  @moduledoc """
  The Orders context.
  """

  import Ecto.Query, warn: false
  alias UnterEats.Repo

  alias UnterEats.Orders.Order

  def list_orders do
    Repo.all(Order)
  end

  def preload_assocs(order) do
    Repo.preload(order, :line_items)
  end

  def list_incoming_orders do
    base_query()
    |> Order.paid_orders()
    |> Repo.all()
  end

  def filter_and_paginate_orders(params \\ %{}) do
    base_query()
    |> filter_by_params(params)
    |> Repo.paginate(params)
  end

  defp base_query do
    Order |> preload(:line_items) |> order_by(desc: :inserted_at)
  end

  defp filter_by_params(query, params) do
    Enum.reduce(params, query, &do_filter_by_params/2)
  end

  defp do_filter_by_params(_, query), do: query

  def get_order!(id), do: Repo.get!(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def broadcast_order_placed!(%Order{paid_at: %DateTime{}} = order) do
    Absinthe.Subscription.publish(UnterEatsWeb.Endpoint, order, order_placed: "orders")
  end

  def mark_order_as_paid(%Order{paid_at: nil} = order, payment_method) do
    with {:ok, order} <-
           update_order(order, %{paid_at: Timex.now(), payment_method: payment_method}) do
      broadcast_order_placed!(order)
    end
  end

  def mark_order_as_fulfilled(%Order{paid_at: %{}, fulfilled_at: %{}}),
    do: {:error, :already_fulfilled}

  def mark_order_as_fulfilled(%Order{paid_at: nil}), do: {:error, :not_paid}

  def mark_order_as_fulfilled(%Order{paid_at: %{}, fulfilled_at: nil} = order) do
    update_order(order, %{fulfilled_at: Timex.now()})
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias UnterEats.Orders.LineItem

  @doc """
  Returns the list of line_items.

  ## Examples

      iex> list_line_items()
      [%LineItem{}, ...]

  """
  def list_line_items do
    Repo.all(LineItem)
  end

  @doc """
  Gets a single line_item.

  Raises `Ecto.NoResultsError` if the Line item does not exist.

  ## Examples

      iex> get_line_item!(123)
      %LineItem{}

      iex> get_line_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_line_item!(id), do: Repo.get!(LineItem, id)

  @doc """
  Creates a line_item.

  ## Examples

      iex> create_line_item(%{field: value})
      {:ok, %LineItem{}}

      iex> create_line_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_line_item(attrs \\ %{}) do
    %LineItem{}
    |> LineItem.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a line_item.

  ## Examples

      iex> update_line_item(line_item, %{field: new_value})
      {:ok, %LineItem{}}

      iex> update_line_item(line_item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_line_item(%LineItem{} = line_item, attrs) do
    line_item
    |> LineItem.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a line_item.

  ## Examples

      iex> delete_line_item(line_item)
      {:ok, %LineItem{}}

      iex> delete_line_item(line_item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_line_item(%LineItem{} = line_item) do
    Repo.delete(line_item)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking line_item changes.

  ## Examples

      iex> change_line_item(line_item)
      %Ecto.Changeset{data: %LineItem{}}

  """
  def change_line_item(%LineItem{} = line_item, attrs \\ %{}) do
    LineItem.changeset(line_item, attrs)
  end
end
