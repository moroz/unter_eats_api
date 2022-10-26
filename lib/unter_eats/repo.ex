defmodule UnterEats.Repo do
  use Ecto.Repo,
    otp_app: :unter_eats,
    adapter: Ecto.Adapters.Postgres
end
