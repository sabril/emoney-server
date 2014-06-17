if @error
  json.result "Error"
  json.message @error
else
  json.result "Success"
  json.key do
    json.renew @renew_key
    json.new_key @key
  end
  json.last_sync_at @server.updated_at.to_i
end