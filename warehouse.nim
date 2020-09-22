import os,io
import std/sha1 
import parsecsv


type
  bridge = object
    source: string
    location: string
    name: string


## Returns a File with the mode of operation, only one type of operation allowed per function 
## Creates it if needed 
proc CsvBaseInit(path:string = "~/.config/warehouse/",mode:FileMode):File=
  let filename = "warehouse.csv" 
  var fst :File 
  assert (open(fst,path & filename,mode) == true)
  return fst

proc HashOfDir(dirname:string, ignore:seq[string] = []):string =
  


proc BuildBridge(arg:bridge,csv:bool= false): string = 
  var delim = " - "
  if csv == true:
    delim = ","
  result = arg.source & delim & arg.location & delim & arg.name

  if csv == true:
    result = result & ";"
  return result

proc AddRef(file,link_bridge,source:string):bool =
  return true

proc ShowReffsTo(file,link_bridge,source:string):seq[bridge] =
  var tab : seq[bridge]
  return tab

proc CheckBroken(): seq[bridge] = 
  # TODO function that goes through all links 
  # and cheks if they exits and returns a list of mistakes
  var links: seq[bridge]
  return links

proc FixBroken(delete:bool= false, interactive:bool = false): bool =
  # TODO function that goes through all links 
  # and fixes them, by deleting/making new links
  # or interactive where it's up to the user
  return true

proc main(): =
  echo "hello_world"
if isMainModule == true:
  main()
