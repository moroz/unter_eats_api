defmodule UnterEats.Users do
  alias UnterEats.Repo
  alias UnterEats.Users.User

  def get_user(id) when is_binary(id) do
    Repo.get(User, id)
  end

  def authenticate_user_by_email_password(email, password) do
    case Repo.get_by(User, email: email) do
      %User{password_hash: hash} = user ->
        if Bcrypt.verify_pass(password, hash) do
          {:ok, user}
        else
          :error
        end

      _ ->
        Bcrypt.no_user_verify()
        :error
    end
  end

  def create_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end
end
