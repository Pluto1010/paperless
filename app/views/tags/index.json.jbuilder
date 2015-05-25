json.array!(@tags) do |tag|
  json.extract! tag, :id, :name, :color, :icon
  json.url tag_url(tag, format: :json)
end
