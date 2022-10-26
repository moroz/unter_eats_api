defmodule UnterEats.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `UnterEats.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description_en: "some description_en",
        description_pl: "some description_pl",
        name_en: "some name_en",
        name_pl: "some name_pl",
        price: "120.5",
        slug: "some slug"
      })
      |> UnterEats.Products.create_product()

    product
  end
end
