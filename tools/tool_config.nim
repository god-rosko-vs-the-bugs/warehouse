import tables
var config = initTable[string,string]()
var config_file_name= "~/.config/warehouse/"

proc CnfigTool():bool=
  


proc GetConfigProperty*(label:string,default:seq[string] = @[]):seq[string]=
  try:
    result = config[label]
  except KeyError:
    result = default
