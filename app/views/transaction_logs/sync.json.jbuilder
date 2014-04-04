if @error
  json.result "error"
  json.message @error
else
  json.result "success"
  json.balance @account_balance
  json.success_logs @success_logs
end
json.key do
  json.renew @renew_key
  json.key @key
end
json.last_sync_at @server.updated_at.to_i