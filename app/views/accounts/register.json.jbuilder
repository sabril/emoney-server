if @error
  json.result "Error"
  json.message @error
else
  json.result "Success"
  json.key @key
  json.last_sync_at @server.updated_at.to_i
  json.balance @account.balance.to_i
end