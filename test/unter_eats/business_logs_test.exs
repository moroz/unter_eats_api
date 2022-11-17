defmodule UnterEats.BusinessLogsTest do
  use UnterEats.DataCase

  alias UnterEats.Store
  alias UnterEats.Store.BusinessLog

  describe "open_store/0" do
    test "creates a BusinessLog when not open" do
      {:ok, %BusinessLog{}} = Store.open_store()
    end

    test "returns {:error, :already_open} when already open" do
      {:ok, %BusinessLog{}} = Store.open_store()
      {:error, :already_open} = Store.open_store()
    end
  end

  describe "current_log/0" do
    test "returns nil when not open" do
      nil = Store.current_log()
    end

    test "returns the current BusinessLog when open" do
      {:ok, %BusinessLog{} = expected} = Store.open_store()

      actual = %BusinessLog{} = Store.current_log()
      assert actual.id == expected.id
    end
  end

  describe "is_store_open?/0" do
    test "returns false when not open" do
      false = Store.is_store_open?()
    end

    test "returns true when open" do
      {:ok, _} = Store.open_store()
      true = Store.is_store_open?()
    end
  end

  describe "close_store/0" do
    test "returns {:ok, log} if the store was open" do
      {:ok, %BusinessLog{} = expected} = Store.open_store()

      {:ok, actual} = Store.close_store()
      assert actual.id == expected.id
    end

    test "returns {:error, :not_open} if the log has been finalized" do
      {:ok, _} = Store.open_store()
      {:ok, _} = Store.close_store()
      {:error, :not_open} = Store.close_store()
    end

    test "returns {:error, :not_open} when no log exists" do
      {:error, :not_open} = Store.close_store()
    end
  end
end
