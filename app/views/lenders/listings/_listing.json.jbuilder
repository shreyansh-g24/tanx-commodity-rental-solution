json.id listing.id
json.selection_strategy listing.selection_strategy
json.status listing.status
json.quote_price_per_month listing.quote_price_per_month

if listing.selected_bid.present?
  json.selected_bid do
    json.partial! "renters/bids/bid", bid: listing.selected_bid
  end
end

json.commodity do
  json.partial! "lenders/commodities/commodity", commodity: listing.commodity
end
