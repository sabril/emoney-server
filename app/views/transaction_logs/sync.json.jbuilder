if @error
  json.result "error"
  json.message @error
else
  json.result "success"
  json.balance @account_balance
end
json.key @key