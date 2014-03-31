if @error
  json.result "Error"
  json.message @error
else
  json.result "Success"
  json.key @key
  json.balance @account.balance
end