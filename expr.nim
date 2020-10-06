import osproc
import sequtils
import strutils
import strformat

proc pred(st:string):bool= 
  return st != ""


var result:string = execProcess("git -C $(pwd) --no-pager branch")
echo result.split("\n").filter(pred).map(removePrefix(@[" ","*"]))
