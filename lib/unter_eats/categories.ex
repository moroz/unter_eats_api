defmodule UnterEats.Categories do
  @moduledoc """
  The Categories context.
  """

  import Ecto.Query, warn: false
  alias UnterEats.Repo

  alias UnterEats.Categories.Category

  def list_categories do
    Repo.all(Category)
  end

  def preload_assocs(category) do
    Repo.preload(category, :products)
  end

  def get_category!(id), do: Repo.get!(Category, id)

  def get_category_by_slug_or_id!(id) do
    Repo.get_by_slug_or_id!(Category, id)
  end

  def create_category(attrs \\ %{}) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end
end
