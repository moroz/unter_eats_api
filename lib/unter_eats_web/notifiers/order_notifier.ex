defmodule UnterEatsWeb.OrderNotifier do
  use Phoenix.Swoosh, view: UnterEatsWeb.MailerView, layout: {UnterEatsWeb.MailerView, :layout}

  alias UnterEats.Orders
  alias UnterEats.Orders.Order

  def order_placed(%Order{} = order) do
    order = Orders.preload_assocs(order)

    new()
    |> from({"Artesano Sports Bar", "zamowienia@artesanokoszalin.pl"})
    |> set_user_to(order)
    |> subject("Potwierdzenie zamówienia")
    |> assign(:order, order)
    |> render_body("order_placed.html")
  end

  defp set_user_to(email, order) do
    full_name = [order.first_name, order.last_name] |> Enum.filter(&is_nil/1) |> Enum.join(" ")
    to(email, {full_name, order.email})
  end
end
