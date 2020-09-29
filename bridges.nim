import os
import streams
import strformat
import parsecsv
import bitops
import strutils

type
  bridge = object
    source: string
    location: string
    link_name: string

type
  OpFlags = enum
    override = 1,
    fix = 2,
    prompt = 4,

proc Bridge(init:seq[string]):bridge = 
  if init.len == 3:
     return  bridge(source : init[0],location:init[1],link_name:init[2])
  raiseAssert (fmt"Incorrect entry in csv {init}") 

proc BuildBridge(arg:bridge): string = 
  let delim = ","
  result = arg.source & delim & arg.location & delim & arg.link_name
  result = result & ";"
  return result

proc BuildBridge(source,location,name:string): string = 
  let delim = ","
  result = source & delim & location & delim & name
  result = result & ";"
  return result

proc BuildBridge(arg:seq[string]): string = 
  let delim = ","
  result ="" 
  if arg.len >= 3:
    result = arg[0] & delim & arg[1] & delim & arg[2] & ";"
  return result

proc ShowReffsTo(source,KeeperCsvName:string):seq[bridge] =
  #TODO add a standard lock(file) checker  
  var 
    tab : seq[bridge]
    file_stream = newFileStream(KeeperCsvName, fmRead)  

  if file_stream == nil:
    raiseAssert("Could not open file " & KeeperCsvName)
  var Reader: CsvParser
  open(Reader, file_stream,KeeperCsvName,separator=',')
  while readRow(Reader):
    if source == Reader.row[0]:
      tab.add(Bridge(Reader.row))
    elif source == "":
      tab.add(Bridge(Reader.row))
  close(file_stream)
  return tab

# TODO make it so that thare is a bitset of override parameters 
# instead of just a bool that is passed as a parameter

proc AddRef(main_warehouse,source,location,name,KeeperCsvName:string, flags:int  = 0) =
  #TODO add a standard lock(file) checker  
  let 
    link_src = main_warehouse & "/" & source
    link_dst = location & "/" & name
  var
    entry :string = BuildBridge(link_src,location,name)
    KeeperCsvFile :File = open(KeeperCsvName,fmAppend)
  if KeeperCsvFile == nil:
    raiseAssert(fmt"Could no open file for writing {KeeperCsvName}")
  if symlinkExists(link_dst):
    if bool(flags.bitand(int(override))):
      close(KeeperCsvFile)
      raiseAssert(fmt"Link {link_dst} already exists")
    else :
     echo fmt"Overriting existing link {link_dst}"
  try:
    createSymlink(link_src,link_dst)
  except OsError:
    close(KeeperCsvFile)
    raiseAssert(fmt"Could not create a link between {link_src} and {link_dst}")
  write(KeeperCsvFile,entry)
  close(KeeperCsvFile)
proc CheckBroken(KeeperCsvName:string, flags:int ): seq[bridge] = 
  # TODO function that goes through all links 
  # and cheks if they exits and returns a list of mistakes

  var LinkTable: seq[bridge] =  ShowReffsTo("",KeeperCsvName)
  var Broken: seq[bridge]
  var source,destination: string

  for entry in items(LinkTable):
    source = entry.source
    destination = entry.location & "/" & entry.link_name
    if symlinkExists(destination) == false :
      if bool(flags.bitand(int(fix))):
        createSymlink(source,destination)
      elif bool(flags.bitand(int(fix))):
        
  return

proc FixBroken(delete:bool= false, interactive:bool = false): bool =
  # TODO function that goes through all links 
  # and fixes them, by deleting/making new links
  # or interactive where it's up to the user
  return true
