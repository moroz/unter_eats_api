defmodule UnterEats.Repo.Migrations.CreateBusinessLogs do
  use Ecto.Migration

  def change do
    create table(:business_logs) do
      add :start_time, :naive_datetime, null: false
      add :end_time, :naive_datetime
    end

    execute "CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;"

    execute """
    ALTER TABLE business_logs
      ADD CONSTRAINT business_logs_cannot_overlap
      exclude USING gist (tsrange(start_time, end_time) WITH &&);
    """
  end
end
