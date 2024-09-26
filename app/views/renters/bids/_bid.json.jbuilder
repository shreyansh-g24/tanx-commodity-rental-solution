json.user do
  json.partial! "users/user", user: bid.user
end

if local_assigns[:show_listing]
  json.listing do
    json.partial! "lenders/listings/listing", listing: bid.listing
  end
end

json.price_per_month bid.price_per_month
json.number_of_months bid.number_of_months
