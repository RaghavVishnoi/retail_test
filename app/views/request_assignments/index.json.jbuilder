json.array!(@request_assignments) do |request_assignment|
  json.extract! request_assignment, :id
  json.url request_assignment_url(request_assignment, format: :json)
end
