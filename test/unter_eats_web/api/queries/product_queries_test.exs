defmodule UnterEatsWeb.Api.Queries.ProductQueriesTest do
  use UnterEatsWeb.GraphQLCase

  @query """
  query PaginateProducts($params: ProductPaginationParams!) {
    paginateProducts(params: $params) {
      pageInfo {
        page
        pageSize
        totalPages
        totalEntries
      }
      data {
        id
        price
        namePl
        descriptionPl
        nameEn
        descriptionEn
        slug
      }
    }
  }
  """

  setup do
    user = insert(:user)
    paneer = insert(:product, name_pl: "Paneer vindaloo", price: 30, slug: "paneer-vindaloo-abcd")
    aloo_gobi = insert(:product, name_pl: "Aloo gobi", price: 42, slug: "aloo-gobi-1234")
    ~M{user, paneer, aloo_gobi}
  end

  describe "paginateProducts query" do
    test "blocks access to when not signed in" do
      vars = %{params: %{q: "daal", page: 2}}

      %{data: nil, errors: [error]} = query(@query, vars)
      %{message: message, path: ["paginateProducts"]} = error
      assert message =~ ~r/authenticate/i
    end

    test "returns a page of products when called with a valid user",
         ~M{user, paneer, aloo_gobi} do
      vars = %{params: %{}}
      %{"paginateProducts" => %{"data" => actual}} = query_with_user(@query, user, vars)

      [first, second] = actual
      assert first["namePl"] == aloo_gobi.name_pl
      assert second["namePl"] == paneer.name_pl
    end
  end
end
