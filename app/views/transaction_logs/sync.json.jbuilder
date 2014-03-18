json.result "success"
json.key @key

# {
#    "header": {
#       "ACCN" : int (15 digit account ID from config file and log database)
#       "HWID" : int (7 digit number hardware ID fetched from USB reader)
#       "numOfLog": int (n number of log following this header)
#       "signature": string (hex value of SHA256 hash written as string)
#   “last_sync_at”: int (convert from DateTime)
#    }
# 
#    "logs":[
#    {
#           "NUM": int (decimal representation of 3 byte NUM field)
#           "PT": int (decimal representation of 1 byte PT field)
#           "Binary ID": int (decimal representation of 4 byte Binary ID field)
#     "ACCN-R": int (decimal representation of 6 byte ACCN-R field)
#           "ACCN-S": int (decimal representation of 6 byte ACCN-S field)
#           "AMNT": int (decimal representation of 4 byte AMNT field)
#           "TS": int (decimal representation of 4 byte TS field)
#           "STAT": int (decimal representation of 1 byte STAT field)
#           "CNL": int (decimal representation of 1 byte CNL field)
#      },
#   {
#           "NUM":
#           "PT":
#           ...
#     "CNL":
#      },
#   {
#     …
#   }
#   
#    ]
# }