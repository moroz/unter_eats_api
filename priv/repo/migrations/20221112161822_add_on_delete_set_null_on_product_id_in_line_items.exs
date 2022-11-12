defmodule UnterEats.Repo.Migrations.AddOnDeleteSetNullOnProductIdInLineItems do
  use Ecto.Migration

  def up do
    execute "alter table line_items drop constraint line_items_product_id_fkey;"

    execute "alter table line_items add constraint line_items_product_id_fkey foreign key (product_id) references products (id) on delete set null;"
  end

  def down do
    execute "alter table line_items drop constraint line_items_product_id_fkey;"

    execute "alter table line_items add constraint line_items_product_id_fkey foreign key (product_id) references products (id);"
  end
end
