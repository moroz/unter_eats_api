defmodule UnterEatsWeb.Api.Resolvers.UserResolvers do
  def current_user(_, %{context: %{current_user: user}}) do
    {:ok, user}
  end
end
