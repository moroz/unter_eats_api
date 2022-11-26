defmodule UnterEatsWeb.MailerView do
  use UnterEatsWeb, :view

  alias UnterEats.Orders.Order

  def format_payment_method(%Order{payment_method: method}), do: format_payment_method(method)

  def format_payment_method("blik"), do: " BLIK-iem"
  def format_payment_method("p24"), do: " przelewem"
  def format_payment_method("card"), do: " kartą"
  def format_payment_method(_), do: ""
end
