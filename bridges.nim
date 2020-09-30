import os
import streams
import strformat
import parsecsv
import bitops
import strutils

import inter


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
    write_to = 8


proc testFlag(flag_reg:int,to_test:OpFlags):bool=
    return bool(flag_reg.bitand(int(to_test)))


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


proc ShowReffsTo(Source,KeeperCsvName:string):seq[bridge] =
  #TODO add a standard lock(file) checker  
  var 
    tab : seq[bridge]
    file_stream = newFileStream(KeeperCsvName, fmRead)  

  if file_stream == nil:
    raiseAssert("Could not open file " & KeeperCsvName)
  var Reader: CsvParser
  open(Reader, file_stream,KeeperCsvName,separator=',')
  while readRow(Reader):
    if Source == Reader.row[0]:
      tab.add(Bridge(Reader.row))
    elif Source == "":
      tab.add(Bridge(Reader.row))
  close(file_stream)
  return tab

proc OverrwriteFile(KeeperCsvName:string,NewLinks:seq[bridge])=
  var tmp_file = KeeperCsvName & ".tmp"
  var tmp_file_handle:File = open(tmp_file,fmWrite)
  if tmp_file_handle == nil:
    raiseAssert(fmt"Could no open file for writing {KeeperCsvName}")
  try:
    for link in items(NewLinks):
      write(tmp_file_handle , BuildBridge(link) & "\n" )
  except IOError:
    close(tmp_file_handle)
    removeFile(tmp_file)
    raiseAssert("IO ERROR when writing to file ")
  try:
    moveFile(tmp_file,KeeperCsvName)
  except OSError:
    removeFile(tmp_file)
    raiseAssert(fmt"Could not overwrite file {KeeperCsvName}")

proc AddRef(main_warehouse,Source,location,name,KeeperCsvName:string, Flags:int  = 0) =
  #TODO add a standard lock(file) checker  
  let 
    Source = main_warehouse & "/" & Source
    Destination = location & "/" & name
  var
    entry :string = BuildBridge(Source,location,name)
    KeeperCsvFile :File = open(KeeperCsvName,fmAppend)
  if KeeperCsvFile == nil:
    raiseAssert(fmt"Could no open file for writing {KeeperCsvName}")
  if symlinkExists(Destination) and Source == expandSymlink(Destination):
    if testFlag(Flags,override):
      close(KeeperCsvFile)
      raiseAssert(fmt"Link {Destination} already exists")
    else :
     echo fmt"Overriting existing link {Destination}"
  try:
    createSymlink(Source,Destination)
  except OsError:
    close(KeeperCsvFile)
    raiseAssert(fmt"Could not create a link between {Source} and {Destination}")
  write(KeeperCsvFile,entry)
  close(KeeperCsvFile)


proc BrokenBridges(KeeperCsvName:string, Flags:int ): seq[bridge] = 
  # TODO function that goes through all links 
  var LinkTable: seq[bridge] =  ShowReffsTo("",KeeperCsvName)
  var Broken: seq[bridge]
  var Source,Destination: string
  var Interaction: int 
  for entry in items(LinkTable):
    Source = entry.source
    Destination = entry.location & "/" & entry.link_name
    if symlinkExists(Destination) and Source == expandSymlink(Destination):
      if testFlag(Flags,fix):
        createSymlink(Source,Destination)
      elif testFlag(Flags,prompt):
        Interaction = CaptureInteraction(fmt"Do you want to Delete broken link {Source} -> {Destination} y/n:",@["y","yes","ye"],@["no","n"])
        case Interaction:
          of 1:
            if tryRemoveFile(Destination) == false:
              stderr.write(fmt"Could not delete symlink {Destination}")
            else:
              echo fmt"Removed symlink {Destination}"
          of -1:
            Broken.add(entry)
          else:
            if testFlag(Flags,fix):
              try:
                createSymlink(Source,Destination)
              except OsError:
                stderr.write(fmt"Could NOT REcreate link between {Source} -> {Destination}") 
  ##TODO get user input if he wants to create delete for now 
  return Broken

proc RemoveBrokenBridges(KeeperCsvName:string, Flags:int, KillList:seq[bridge])=
  var BrokenLinks: seq[bridge] = BrokenBridges(KeeperCsvName,Flags)
  var AllLinks: seq[bridge]= ShowReffsTo("",KeeperCsvName)
  var New_Links: seq[bridge]
  for broken in items(BrokenLinks):
    if broken in AllLinks:
      ##link is broken so we continue 
      continue
    else:
      New_Links.add(broken)

    OverrwriteFile(KeeperCsvName, New_Links)
