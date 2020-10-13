import os
import strformat

proc SendToWarehouse*(filename,warehouse:string,remnant_link:bool=false):bool=
  var cut_name:string
  if filename[filename.len-1] == '/':
    cut_name = filename[0..<filename.len-1]
  else:
    cut_name = filename

  var FileInformation = getFileInfo(cut_name)
  var (path,name,ext) = splitFile(cut_name)   
  var target_name:string = name & ext
  case FileInformation.kind:
    of pcDir:
      if dirExists(warehouse & target_name):
        stderr.write (fmt"Directory {target_name} exist in warehouse")
        raiseAssert(fmt"Directory {target_name} exist in warehouse")
      else:
        moveFile(filename,warehouse & target_name)
        if remnant_link:
          createSymlink(warehouse & target_name,filename)
    of pcFile:
      if fileExists (warehouse & target_name):
        stderr.write (fmt"File {target_name} exist in warehouse")
        raiseAssert (fmt"File {target_name} exist in warehouse")
      else:
        moveFile(filename,warehouse & target_name)
        if remnant_link:
          createSymlink(warehouse & target_name,filename)
    else:
      stderr.write( fmt"Cannot store {filename} : is already a link! -> " & expandSymlink(filename))
