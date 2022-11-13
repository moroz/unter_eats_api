defmodule UnterEats.Images.Image do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "images" do
    belongs_to :product, UnterEats.Products.Product

    timestamps()
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:product_id])
    |> validate_required([:product_id])
  end
end
