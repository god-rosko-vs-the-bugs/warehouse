import tables
var config = initTable[string,string]()

config["warehouse locations"]="~/.config/warehouse/"
config["repo manifest name"]="manifest.csv"



proc GetConfigProperty*(label:string,value:var string,default:string = ""):bool=
  try:
    value = config[label]
    return true
  except KeyError:
    value = default
    return false

proc AddConfigPropery*(label,value:string,override : bool = true):bool=
  try:
    if config[label]:
      
  except KeyError:
    value = default
    return false
