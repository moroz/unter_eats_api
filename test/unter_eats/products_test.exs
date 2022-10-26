defmodule UnterEats.ProductsTest do
  use UnterEats.DataCase

  alias UnterEats.Products

  describe "products" do
    alias UnterEats.Products.Product

    import UnterEats.ProductsFixtures

    @invalid_attrs %{description_en: nil, description_pl: nil, name_en: nil, name_pl: nil, price: nil, slug: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Products.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Products.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{description_en: "some description_en", description_pl: "some description_pl", name_en: "some name_en", name_pl: "some name_pl", price: "120.5", slug: "some slug"}

      assert {:ok, %Product{} = product} = Products.create_product(valid_attrs)
      assert product.description_en == "some description_en"
      assert product.description_pl == "some description_pl"
      assert product.name_en == "some name_en"
      assert product.name_pl == "some name_pl"
      assert product.price == Decimal.new("120.5")
      assert product.slug == "some slug"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Products.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()
      update_attrs = %{description_en: "some updated description_en", description_pl: "some updated description_pl", name_en: "some updated name_en", name_pl: "some updated name_pl", price: "456.7", slug: "some updated slug"}

      assert {:ok, %Product{} = product} = Products.update_product(product, update_attrs)
      assert product.description_en == "some updated description_en"
      assert product.description_pl == "some updated description_pl"
      assert product.name_en == "some updated name_en"
      assert product.name_pl == "some updated name_pl"
      assert product.price == Decimal.new("456.7")
      assert product.slug == "some updated slug"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Products.update_product(product, @invalid_attrs)
      assert product == Products.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Products.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Products.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Products.change_product(product)
    end
  end
end
