json.array!(@sales_orders) do |sales_order|
  json.extract! sales_order, :id
  json.url sales_order_url(sales_order, format: :json)
end
