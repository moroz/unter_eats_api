defmodule UnterEats.Repo.Migrations.AddShippingFeeToOrders do
  use Ecto.Migration

  def up do
    alter table(:orders) do
      add :shipping_fee, :decimal, null: false, default: 0
    end

    execute """
    with totals as (
      select o.id order_id, sum(li.quantity * li.product_price) total
      from orders o 
      join line_items li on li.order_id = o.id
      group by 1
    )
    update orders o set shipping_fee = (case when o."delivery_type" = 'pickup' or t.total >= 100 then 0 else 15 end)
    from totals t
    where t.order_id = o.id; 
    """
  end

  def down do
    alter table(:orders) do
      remove :shipping_fee
    end
  end
end
