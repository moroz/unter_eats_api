defmodule UnterEats.Users do
  alias UnterEats.Repo
  alias UnterEats.Users.User

  def get_user(id) when is_binary(id) do
    Repo.get(User, id)
  end

  def authenticate_user_by_email_password(email, password) do
    User
    |> Repo.get_by(email: email)
    |> Bcrypt.check_pass(password, hide_user: true)
  end
end
