defmodule UnterEats.SlugHelpers do
  import Ecto.Changeset

  def slugify(name) when is_binary(name) do
    Slug.slugify(name) <> "-" <> random_hex()
  end

  def random_hex(length \\ 4) when is_integer(length) and rem(length, 2) == 0 do
    length
    |> Kernel./(2)
    |> round()
    |> :crypto.strong_rand_bytes()
    |> Base.encode16(case: :lower)
  end

  def maybe_set_slug(%Ecto.Changeset{} = changeset, base_field \\ :name_pl) do
    with nil <- get_field(changeset, :slug),
         name when is_binary(name) and name != "" <- get_field(changeset, base_field) do
      slug = slugify(name)
      put_change(changeset, :slug, slug)
    end
  end
end
