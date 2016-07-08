json.array!(@tat_groups) do |tat_group|
  json.extract! tat_group, :id
  json.url tat_group_url(tat_group, format: :json)
end
