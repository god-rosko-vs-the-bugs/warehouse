import os
import sequtils
import tool_config


let arguments_short = [ "-s",
                        "-f",
                        "-r",
                        "-p",
                        "-c",
                        "-m",
                        "-i"]

let arguments_long = [  "--stow",
                        "--force",
                        "--repo",
                        "--pull",
                        "--clean",
                        "--merge",
                        "--interactive"]

let arguments_inter =["stow",
                      "force",
                      "repo",
                      "pull",
                      "clean",
                      "merge"]

proc DebugArgs(input_params:seq[seq[string]])=
  for i in items(input_params):
    echo i[0] & "\n"
    for j in items(i[1..<(i.len()-1)]):
      echo ( "\t \\"  & j & " \n" )
    echo "\n"

proc CheckErrors(line_values:seq[string]): bool =
  return false

proc ParseInputs(): seq[seq[string]] = 
  var cmd  = commandLineParams()
  var input_params : seq[seq[string]]
  var last = 0
  for i in items(cmd):
    if i in arguments_short or i in arguments_long :
      last+=1
    input_params[last].add(i)
  when defined(debug):
    DebugArgs(input_params)
  return  input_params

proc InputConfigParse(): seq[seq[string]] = 
  var input_params = ParseInputs()

