json.listings listings.map do |listing|
  json.partial! "lenders/listings/listing", listing: listing
end
