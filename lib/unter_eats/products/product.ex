defmodule UnterEats.Products.Product do
  use UnterEats.Schema
  import Ecto.Changeset
  alias UnterEats.SlugHelpers

  schema "products" do
    field :description_en, :string
    field :description_pl, :string
    field :name_en, :string
    field :name_pl, :string
    field :price, :decimal
    field :slug, :string
    field :in_stock, :boolean, default: true

    has_one :image, UnterEats.Images.Image
    has_many :products_categories, UnterEats.Products.ProductCategory
    has_many :categories, through: [:products_categories, :category]

    timestamps()
  end

  @required ~w[name_pl price]a
  @cast @required ++ ~w[name_en slug description_pl description_en in_stock]a

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @cast)
    |> validate_required(@required)
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> SlugHelpers.maybe_set_slug()
    |> validate_required([:slug])
  end
end
