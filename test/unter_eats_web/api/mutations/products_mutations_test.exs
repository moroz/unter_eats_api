defmodule UnterEatsWeb.Api.Mutations.ProductsMutationsTest do
  use UnterEatsWeb.GraphQLCase
  alias UnterEats.Products.Product

  setup do
    [user: insert(:user)]
  end

  @mutation """
  mutation CreateProduct($params: CreateProductParams!){
    createProduct(params: $params) {
      success
      data {
        id
        namePl
        nameEn
        descriptionEn
        descriptionPl
        slug
        price
      }
      errors {
        key
        message
      }
    }
  }
  """

  describe "createProduct mutation" do
    test "denies access when called without user" do
      params = params_for(:product)
      vars = %{params: params}

      %{data: %{"createProduct" => %{"success" => false, "data" => nil, "errors" => [error]}}} =
        mutate(@mutation, vars)

      assert error["message"] =~ ~r/authenticate/i
      assert Repo.count(Product) == 0
    end

    test "creates product when called with valid params", ~M{user} do
      params = params_for(:product, price: 18.5, name_en: "Some product")
      vars = %{params: params}

      %{"createProduct" => %{"success" => true, "data" => actual, "errors" => []}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["namePl"] == params.name_pl
      assert actual["nameEn"] == params.name_en
      assert actual["price"] == "18.5"
    end

    test "returns errors when called with invalid params", ~M{user} do
      params = params_for(:product, price: -20)
      vars = %{params: params}

      %{"createProduct" => %{"success" => false, "data" => nil, "errors" => [error]}} =
        mutate_with_user(@mutation, user, vars)

      assert error["key"] == "price"
      assert error["message"] =~ ~r/greater than/i
      assert Repo.count(Product) == 0
    end
  end

  @mutation """
  mutation UpdateProduct($id: ID!, $params: UpdateProductParams!){
    updateProduct(id: $id, params: $params) {
      success
      data {
        id
        namePl
        nameEn
        descriptionEn
        descriptionPl
        slug
        price
      }
      errors {
        key
        message
      }
    }
  }
  """

  describe "updateProduct mutation" do
    setup do
      [product: insert(:product)]
    end

    @valid_params %{
      name_pl: "Updated name in Polish",
      name_en: "Updated English name",
      description_pl: "Updated PL description",
      description_en: "Updated EN description",
      price: 43
    }

    test "denies access when called without user", ~M{product} do
      vars = %{id: product.id, params: @valid_params}

      %{data: %{"updateProduct" => %{"success" => false, "data" => nil, "errors" => [error]}}} =
        mutate(@mutation, vars)

      assert error["message"] =~ ~r/authenticate/i
      assert Repo.reload(product) == product
    end

    test "updates product with valid params", ~M{user, product} do
      vars = %{id: product.id, params: @valid_params}

      %{"updateProduct" => %{"success" => true, "data" => actual, "errors" => []}} =
        mutate_with_user(@mutation, user, vars)

      assert actual["namePl"] == @valid_params.name_pl
      assert actual["nameEn"] == @valid_params.name_en
      assert actual["descriptionPl"] == @valid_params.description_pl
      assert actual["descriptionEn"] == @valid_params.description_en
      assert actual["price"] == "43"
    end

    test "does not update product with invalid params", ~M{user, product} do
      vars = %{id: product.id, params: %{@valid_params | name_pl: ""}}

      %{"updateProduct" => %{"success" => false, "data" => nil, "errors" => [error]}} =
        mutate_with_user(@mutation, user, vars)

      assert error["key"] == "namePl"
      assert error["message"] =~ "can't be blank"
    end
  end
end
