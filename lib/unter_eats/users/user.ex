defmodule UnterEats.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :full_name, :string
    field :password_hash, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password_hash, :full_name])
    |> validate_required([:email, :password_hash, :full_name])
    |> unique_constraint(:email)
  end
end
