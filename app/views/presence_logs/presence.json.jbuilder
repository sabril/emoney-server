unless @error
  json.result "success"
else
  json.result "error"
  json.message @error
end