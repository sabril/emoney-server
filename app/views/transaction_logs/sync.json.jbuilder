if @error
  json.result "error"
  json.message @error
else
  json.result "success"
  json.balance @account_balance
end
if @key
  json.key @key
  json.last_sync_at @server.updated_at.to_i
end