json.message message
json.user do
  json.partial! "user", user: user
end
