defmodule UnterEats.Store do
  @moduledoc """
  The `UnterEats.Store` context. Contains functions that help keep track
  of the store's actual opening hours. Order can only be placed when the
  store is open for business.
  """

  alias UnterEats.Repo
  alias UnterEats.Store.BusinessLog
  import Ecto.Query

  def open_store do
    case current_log() do
      nil ->
        do_open_store()

      %BusinessLog{} ->
        {:error, :already_open}
    end
  end

  defp do_open_store do
    %BusinessLog{}
    |> BusinessLog.changeset(%{start_time: Timex.now()})
    |> Repo.insert()
  end

  def current_log do
    BusinessLog
    |> where([b], is_nil(b.end_time))
    |> Repo.one()
  end

  def is_store_open? do
    BusinessLog
    |> where([b], is_nil(b.end_time))
    |> Repo.exists?()
  end

  def close_store do
    case current_log() do
      nil ->
        {:error, :not_open}

      %BusinessLog{} = log ->
        log
        |> BusinessLog.changeset(%{end_time: Timex.now()})
        |> Repo.update()
    end
  end
end
