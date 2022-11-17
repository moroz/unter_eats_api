defmodule UnterEatsWeb.Api.Mutations.StoreMutationsTest do
  use UnterEatsWeb.GraphQLCase
  alias UnterEats.Store

  @mutation """
  mutation OpenStore {
    result: openStore {
      success
      data {
        id
        startTime
        endTime
      }
      errors {
        key
        message
      }
    }
  }
  """

  setup do
    [user: insert(:user)]
  end

  describe "openStore mutation" do
    test "denies access when not signed in" do
      %{data: %{"result" => %{"success" => false, "errors" => [error]}}} = mutate(@mutation, %{})
      assert error["message"] =~ "authenticate"
    end

    test "opens the store when not open yet", ~M{user} do
      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, %{})

      assert {:ok, _, 0} = DateTime.from_iso8601(actual["startTime"])
      refute actual["endTime"]
    end

    test "does not open the store and returns error when already open", ~M{user} do
      Store.open_store()

      %{"result" => %{"success" => false, "errors" => [error], "data" => nil}} =
        mutate_with_user(@mutation, user, %{})

      assert error["message"] =~ ~r/already open/i
    end
  end

  @mutation """
  mutation CloseStore {
    result: closeStore {
      success
      data {
        id
        startTime
        endTime
      }
      errors {
        key
        message
      }
    }
  }
  """

  describe "closeStore mutation" do
    test "denies access when not signed in" do
      %{data: %{"result" => %{"success" => false, "errors" => [error]}}} = mutate(@mutation, %{})
      assert error["message"] =~ "authenticate"
    end

    test "closes the store when open", ~M{user} do
      start_time =
        Timex.now() |> Timex.shift(hours: -1) |> Timex.to_datetime() |> DateTime.truncate(:second)

      insert(:business_log, start_time: start_time)

      %{"result" => %{"success" => true, "errors" => [], "data" => actual}} =
        mutate_with_user(@mutation, user, %{})

      assert {:ok, ^start_time, 0} = DateTime.from_iso8601(actual["startTime"])
      assert {:ok, end_time, 0} = DateTime.from_iso8601(actual["endTime"])

      assert Timex.after?(end_time, start_time)
      refute Timex.after?(end_time, Timex.now())
    end

    test "does not close the store and returns error when not open", ~M{user} do
      %{"result" => %{"success" => false, "errors" => [error], "data" => nil}} =
        mutate_with_user(@mutation, user, %{})

      assert error["message"] =~ ~r/not open/i
    end
  end
end
