import os
import strformat

proc Get

proc SendToWarehouse*(filename,warehouse:string,remnant_link:bool=false):bool=
  var FileInformation = getFileInfo(filename)
  var cut_name:string
  if filename[filename.len-1] == '/':
    
  case FileInformation.kind:
    of pcDir:

      echo "is dir"
    of pcFile:
      echo "is file"
    else: 
      stderr.write( fmt"Cannot store {filename} : is already a link! ")




