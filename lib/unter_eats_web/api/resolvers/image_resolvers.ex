defmodule UnterEatsWeb.Api.Resolvers.ImageResolvers do
  alias UnterEats.Images
  alias UnterEats.Products

  def upload_product_image(%{product_id: product_id, image: image}, _) do
    product = Products.get_product!(product_id)

    with {:ok, _} <- Images.create_product_image(product, image) do
      {:ok, product}
    end
  end
end
