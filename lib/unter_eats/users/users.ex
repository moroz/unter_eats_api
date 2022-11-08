defmodule UnterEats.Users do
  alias UnterEats.Repo
  alias UnterEats.Users.User

  def get_user(id) when is_binary(id) do
    Repo.get(User, id)
  end
end
