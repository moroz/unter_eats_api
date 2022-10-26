defmodule UnterEats.CategoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UnterEats.Categories` context.
  """

  @doc """
  Generate a unique category slug.
  """
  def unique_category_slug, do: "some slug#{System.unique_integer([:positive])}"

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name_en: "some name_en",
        name_pl: "some name_pl",
        slug: unique_category_slug()
      })
      |> UnterEats.Categories.create_category()

    category
  end
end
