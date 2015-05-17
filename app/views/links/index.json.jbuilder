json.array!(@links) do |link|
  json.extract! link, :id, :title, :URL, :html
  json.url link_url(link, format: :json)
end
