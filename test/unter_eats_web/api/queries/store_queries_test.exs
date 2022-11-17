defmodule UnterEatsWeb.Api.Queries.StoreQueriesTest do
  use UnterEatsWeb.GraphQLCase

  @query """
  query PaginateBusinessLogs($params: BusinessLogPaginationParams!) {
    result: paginateBusinessLogs(params: $params) {
      pageInfo {
        page
        pageSize
        totalPages
        totalEntries
      }
      data {
        id
        startTime
        endTime
      }
    }
  }
  """

  describe "isStoreOpen query" do
    test "denies access when not signed in" do
      vars = %{params: %{page: 1}}
      %{data: nil, errors: [error]} = query(@query, vars)
      %{message: message, path: ["result"]} = error
      assert message =~ ~r/authenticate/i
    end

    @two_days_ago Timex.now() |> Timex.shift(days: -2)
    @end_of_shift @two_days_ago |> Timex.shift(hours: 5)
    @yesterday Timex.now() |> Timex.shift(days: -1)
    @yesterday_end @yesterday |> Timex.shift(hours: 5)

    test "returns a page of business logs when called with a valid user" do
      insert(:business_log, start_time: @two_days_ago, end_time: @end_of_shift)
      insert(:business_log, start_time: @yesterday, end_time: @yesterday_end)
      user = insert(:user)

      vars = %{params: %{}}

      %{
        "result" => %{
          "pageInfo" => %{"page" => 1, "totalEntries" => 2, "totalPages" => 1},
          "data" => actual
        }
      } = query_with_user(@query, user, vars)

      assert length(actual) == 2
    end
  end
end
