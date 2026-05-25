defmodule UnterEatsWeb.Socket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: UnterEatsWeb.Api.Schema
  alias UnterEats.Users.Token
  alias UnterEats.Users.User

  @impl true
  def id(_socket), do: "orders_socket"

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case Token.get_user_by_subscription_token(token) do
      %User{} = user ->
        {:ok, assign(socket, :current_user, user)}

      _ ->
        :error
    end
  end

  def connect(_, _, _), do: :error
end
