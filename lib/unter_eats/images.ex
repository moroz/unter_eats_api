defmodule UnterEats.Images do
  alias UnterEats.Products.Product
  alias UnterEats.Images.Image
  alias UnterEats.ImageUploader
  alias UnterEats.Repo
  import Ecto.Query

  def create_product_image(%Product{} = product, image_file) do
    image = %Image{product_id: product.id, id: Ecto.UUID.generate()}

    with {:ok, _} <- ImageUploader.store({image_file, image}) do
      Repo.insert(image,
        on_conflict: {:replace, [:updated_at, :id]},
        conflict_target: [:product_id]
      )
    end
  end

  def batch_load_product_image_uuids(_, product_ids) do
    Image
    |> where([i], i.product_id in ^product_ids)
    |> select([i], {i.product_id, i.id})
    |> Repo.all()
    |> Map.new()
  end
end
