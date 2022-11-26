defmodule UnterEatsWeb.EmailTestController do
  use UnterEatsWeb, :controller

  alias UnterEats.Orders.Order
  alias UnterEats.Repo
  import Ecto.Query

  def order_placed(conn, _params) do
    order = Order |> Order.paid_orders() |> order_by(:inserted_at) |> last() |> Repo.one!()
    email = UnterEatsWeb.OrderNotifier.order_placed(order)

    send_resp(conn, 200, email.html_body)
  end
end
