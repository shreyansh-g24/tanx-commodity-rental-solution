json.message message
json.bid do
  json.partial! "bid", bid: bid, show_listing: true
end
