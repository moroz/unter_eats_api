defmodule UnterEatsWeb.Socket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: UnterEatsWeb.Api.Schema

  @impl true
  def id(_socket), do: "orders_socket"

  @impl true
  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end
end
