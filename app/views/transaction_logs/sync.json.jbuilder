if @error
  json.result "error"
  json.message @error
else
  json.result "success"
end
json.key @key