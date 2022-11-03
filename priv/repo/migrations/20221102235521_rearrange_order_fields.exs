defmodule UnterEats.Repo.Migrations.RearrangeOrderFields do
  use Ecto.Migration

  alias UnterEats.Orders.Order.DeliveryType

  def change do
    DeliveryType.create_type()

    alter table(:orders) do
      remove :full_name, :string, null: false
      add :first_name, :string, null: false
      add :last_name, :string
      add :phone_no, :string, null: false
      add :remarks, :text
      add :delivery_type, DeliveryType.type()
    end
  end
end
