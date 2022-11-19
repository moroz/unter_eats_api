defmodule UnterEats.Users.Token do
  alias UnterEats.Users
  alias UnterEats.Users.User
  alias UnterEatsWeb.Endpoint

  @salt "subscription token"
  @max_age 86400

  @spec issue_token_for_user(user :: User.t()) :: String.t()
  def issue_token_for_user(%User{} = user) do
    Phoenix.Token.sign(Endpoint, @salt, user.id)
  end

  @spec get_user_by_subscription_token(token :: String.t()) :: User.t() | nil
  def get_user_by_subscription_token(token) when is_binary(token) do
    case Phoenix.Token.verify(Endpoint, @salt, token, max_age: @max_age) do
      {:ok, id} ->
        Users.get_user(id)

      _ ->
        nil
    end
  end
end
