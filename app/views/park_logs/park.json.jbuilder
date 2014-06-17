unless @error
  json.result "success"
  json.status @status
  if @status == "in"
    json.park_key @park_key
  else
    json.amount @amount
  end
else
  json.result "error"
  json.message @error
end