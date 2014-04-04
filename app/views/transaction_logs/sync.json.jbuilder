if @error
  json.result "error"
  json.message @error
else
  json.result "success"
  json.balance @account_balance
end
json.error_logs @error_logs
json.key do
  json.renew @renew_key
  json.key @key
end
json.last_sync_at @server.updated_at.to_i