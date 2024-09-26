json.commodities commodities.map do |commodity|
  json.partial! "commodity", commodity: commodity
end
