defmodule UnterEats.Repo.Migrations.AddOnDeleteCascadeOnProductIdInProductsCategories do
  use Ecto.Migration

  def change do
    execute "alter table products_categories drop constraint products_categories_product_id_fkey;"

    execute "alter table products_categories add constraint products_categories_product_id_fkey foreign key (product_id) references products (id) on delete cascade;"
  end

  def down do
    execute "alter table products_categories drop constraint products_categories_product_id_fkey;"

    execute "alter table products_categories add constraint products_categories_product_id_fkey foreign key (product_id) references products (id);"
  end
end
