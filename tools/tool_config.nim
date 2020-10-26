import sequtils
import strutils
import tables
let config_file_name:string = "~/.config/warehouse/config"
var sconfig : Table[string,seq[string]]

proc DebugConfig()=
  for i in keys(sconfig):
    echo("\t*",i,":")
    for j in items(sconfig[i]):
      echo("\t \\ ", j)

proc ConfigTool*(config:var Table = sconfig):bool=
  var FileSt = open(config_file_name)
  var line:string
  var line_sp:seq[string]
  if FileSt == nil:
    return false
  while readLine(Filest,line):
    line_sp = split(line,":=")
    config[line_sp[0]].add(line_sp[1..<line_sp.len()])
  for i in keys(config):
    config[i] = filter(config[i],proc(x:string):bool = x != "")
  when defined(debug):
    DebugConfig()
  close(FileSt)
  return true

proc GetConfigProperty*(label:string,default:seq[string] = @[]):seq[string]=
  try:
    result = sconfig[label]
  except KeyError:
    result = default
