defmodule UnterEatsWeb.LineItemView do
  use UnterEatsWeb, :view
  alias UnterEatsWeb.LineItemView

  def render("index.json", %{line_items: line_items}) do
    %{data: render_many(line_items, LineItemView, "line_item.json")}
  end

  def render("show.json", %{line_item: line_item}) do
    %{data: render_one(line_item, LineItemView, "line_item.json")}
  end

  def render("line_item.json", %{line_item: line_item}) do
    %{
      id: line_item.id,
      quantity: line_item.quantity
    }
  end
end
