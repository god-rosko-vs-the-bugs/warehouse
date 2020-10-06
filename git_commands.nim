import os
import strformat


proc GetCommandSeqForBranch*(OriginBranch:string):seq[string]=
  return @["fetch origin", fmt"reset --hard origin/{OriginBranch}","clean -f -d"]

proc ExecGitCommandAtDIr*(git_location,command:string):int=
  return execShellCmd (fmt"git --git-dir={git_location}/.git {command}")

proc ExecCommandSeq*(repo_location:string, commands:seq[string]):int=
  var error:int
  for current_command in items(commands):
    error=  ExecGitCommandAtDIr(repo_location,current_command)
    if error > 0:
      return error
    error = 0
  return error


proc ExecGitClone*(git_link:string ,target_location:string="."):int=
  return execShellCmd(fmt"git clone {git_link} {target_location}")


proc CheckoutRepoBreanch*(repo,branch,warehouse:string):int=
  return ExecGitCommandAtDIr(warehouse & "/" & repo, fmt"checkout -c {branch}")
