import os
import sequtils
import tool_config


let arguments_short = [ "-s",
                        "-f",
                        "-r",
                        "-p",
                        "-c",
                        "-m"]

let arguments_long = [  "--stow",
                        "--force",
                        "--repo",
                        "--pull",
                        "--clean",
                        "--merge"]

proc DebugArgs(input_params:seq[seq[string]])=
  for i in items(input_params):
    echo i[0] & "\n"
    for j in items(i[1..<(i.len()-1)]):
      echo ( "\t \\"  & j & " \n" )
    echo "\n"

proc CheckErrors(line_values:seq[string]): bool =
  return false

proc ParseInputs(cmd:seq[TaintedString]): seq[seq[string]] = 
  #var cmd  = commandLineParams()
  var input_params : seq[seq[string]]
  var last = -1
  for i in items(cmd[1..^len(cmd)]):
    if i in arguments_short or i in arguments_long :
      last+=1
    input_params[last].add(i)
  when defined(debug): #ifdef debug
    DebugArgs(input_params)
  return  input_params

proc InputConfigParse(): seq[seq[string]] = 
  var input_params = ParseInputs(commandLineParams())

# tests for this module 

if isMainModule:
  var example_args:seq[seq[string]] = @[
                      @["--repo","manifest.csv"],
                      @["-s","example.nim"],
                      @["--force"],
                      @["--pull","dwm"],
                      @["-c"],
                      @["--merge"]]
  var example_string:string = 


