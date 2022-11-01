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
    %UnterEats.Products.Product{}
  end
end
