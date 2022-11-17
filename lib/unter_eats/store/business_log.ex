defmodule UnterEats.Store.BusinessLog do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "business_logs" do
    field :end_time, :utc_datetime
    field :start_time, :utc_datetime
  end

  @doc false
  def changeset(business_log, attrs) do
    business_log
    |> cast(attrs, [:start_time, :end_time])
    |> validate_required([:start_time])
  end
end
