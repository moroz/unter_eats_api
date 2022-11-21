defmodule UnterEats.Factory do
  use ExMachina.Ecto, repo: UnterEats.Repo

  def random_email do
    rand =
      :crypto.strong_rand_bytes(5)
      |> Base.encode16(case: :lower)

    "#{rand}@example.com"
  end

  @password "foobar"
  @password_hash Bcrypt.hash_pwd_salt(@password)

  def user_factory do
    %UnterEats.Users.User{
      email: random_email(),
      password_hash: @password_hash
    }
  end

  def product_factory do
    %UnterEats.Products.Product{
      name_pl: "Dal tarkari",
      slug: UnterEats.SlugHelpers.slugify("Dal tarkari"),
      price: 42
    }
  end

  def with_name(%UnterEats.Products.Product{} = product, name) when is_binary(name) do
    %{product | name_pl: name, slug: UnterEats.SlugHelpers.slugify(name)}
  end

  def business_log_factory do
    %UnterEats.Store.BusinessLog{}
  end

  def line_item_factory do
    product = build(:product)

    %UnterEats.Orders.LineItem{
      product: product,
      quantity: 1,
      product_name: product.name_pl,
      product_price: product.price
    }
  end

  def order_factory do
    %UnterEats.Orders.Order{
      first_name: "Test",
      last_name: "User",
      email: "user@example.com",
      phone_no: "555123456",
      delivery_type: :pickup,
      line_items: build_list(2, :line_item),
      grand_total: 108
    }
  end

  def paid(%UnterEats.Orders.Order{} = order) do
    %{order | paid_at: Ecto.Schema.__timestamps__(:utc_datetime)}
  end

  def fulfilled(%UnterEats.Orders.Order{} = order) do
    %{order | fulfilled_at: Ecto.Schema.__timestamps__(:utc_datetime)}
  end
end
