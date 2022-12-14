defmodule UnterEats.Repo do
  use Ecto.Repo,
    otp_app: :unter_eats,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20

  import Ecto.Query

  def count(queryable), do: aggregate(queryable, :count)

  def get_by_slug_or_id!(queryable, slug_or_id) when is_binary(slug_or_id) do
    queryable
    |> where([s], fragment("?::text", s.id) == ^slug_or_id or s.slug == ^slug_or_id)
    |> one!()
  end
end
