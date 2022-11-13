defmodule UnterEatsWeb.Api.Resolvers.ImageResolvers do
  alias UnterEats.Images
  alias UnterEats.Products
  import ShorterMaps

  def upload_product_image(~M{product_id, image}, _) do
    product = Products.get_product!(product_id)

    with {:ok, _} <- Images.create_product_image(product, image) do
      {:ok, product}
    end
  end
end
