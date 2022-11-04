defmodule UnterEatsWeb.Api.Middleware.StoreOrderIdInSession do
  @behaviour Absinthe.Middleware

  alias UnterEats.Orders.Order

  def call(%Absinthe.Resolution{value: %Order{} = order} = res, _opts) do
    context = Map.put(res.context, :set_session, order_id: order.id)
    value = %{success: true, data: order, errors: []}
    %{res | context: context, value: value, state: :resolved}
  end

  def call(res, _opts), do: res
end
