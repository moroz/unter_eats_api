defmodule UnterEatsWeb.Api.Resolvers.UserResolvers do
  alias UnterEats.Users.User
  alias UnterEats.Users.Token

  def current_user(_, %{context: %{current_user: user}}) do
    {:ok, user}
  end

  def subscription_token(%User{} = user, _, _) do
    {:ok, Token.issue_token_for_user(user)}
  end
end
