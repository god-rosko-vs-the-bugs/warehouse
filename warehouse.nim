import os,io,streams
import std/sha1 
import parsecsv


type
  bridge = object
    source: string
    location: string
    name: string

#proc CsvBaseInit(path:string = "~/.config/warehouse/",mode:FileMode):File=
#  let filename = "warehouse.csv" 
#  var fst :File 
#  assert (open(fst,path & filename,mode) == true)
#  return fst


proc BuildBridge(arg:bridge): string = 
  let delim = ","
  result = arg.source & delim & arg.location & delim & arg.name
  result = result & ";"
  return result

proc ShowReffsTo(source,sfile_name:string):seq[bridge] =
  var tab : seq[bridge]
  var file_stream = newFileStream
  return tab

proc AddRef(file,link_bridge,source,sfile_name:string):bool =
   
  return true

proc CheckBroken(file_stream:File): seq[bridge] = 
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
