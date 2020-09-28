import os
import streams
import strformat
import parsecsv
import strutils

type
  bridge = object
    source: string
    location: string
    name: string

proc Bridge (init:seq[string]):bridge = 
  if init.len == 3:
    result = bridge(source : init[0],location:init[1],name:init[2])

proc BuildBridge(arg:bridge): string = 
  let delim = ","
  result = arg.source & delim & arg.location & delim & arg.name
  result = result & ";"
  return result

proc ShowReffsTo(source,sfile_name:string):seq[bridge] =
  var tab : seq[bridge]
  var file_stream = newFileStream(sfile_name, fmRead)  
  if file_stream == nil:
    raiseAssert("Could not open file " & sfile_name)
  var Reader: CsvParser
  open(Reader, file_stream,sfile_name,separator=',')
  while readRow(Reader):
    if sfile_name == Reader.row[0]:
      tab.add(Bridge(Reader.row))
  close(file_stream)
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
