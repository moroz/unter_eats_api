defmodule UnterEats.Products.Product do
  use UnterEats.Schema
  import Ecto.Changeset

  schema "products" do
    field :description_en, :string
    field :description_pl, :string
    field :name_en, :string
    field :name_pl, :string
    field :price, :decimal
    field :slug, :string

    has_many :products_categories, UnterEats.Products.ProductCategory
    has_many :categories, through: [:products_categories, :category]

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name_pl, :name_en, :slug, :price, :description_pl, :description_en])
    |> validate_required([:name_pl, :price])
    |> maybe_set_slug()
    |> validate_required([:slug])
  end

  defp maybe_set_slug(%Ecto.Changeset{valid?: true} = changeset) do
    case get_field(changeset, :slug) do
      nil ->
        name_pl = get_field(changeset, :name_pl)
        slug = Slug.slugify(name_pl)
        put_change(changeset, :slug, slug)

      _ ->
        changeset
    end
  end

  defp maybe_set_slug(changeset), do: changeset
end
