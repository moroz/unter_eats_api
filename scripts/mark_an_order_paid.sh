#!/bin/sh -e

order_id=$(psql unter_eats_dev -A -t -c 'select id from orders where paid_at is null limit 1' | tr -d '\n')

stripe trigger payment_intent.succeeded --override payment_intent:metadata.order_id=$order_id
