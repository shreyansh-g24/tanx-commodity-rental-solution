json.bids bids.map do |bid|
  json.partial! "bid", bid: bid, show_listing: true
end
