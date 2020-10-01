import tables
var config = initTable[string,string]()

config["warehouse locations"]="~/.config/warehouse/"

proc GetConfigProperty*(label:string,value:var string):bool=
  try:
    value = config[label]
    return true
  except KeyError:
    value = ""
    return false

