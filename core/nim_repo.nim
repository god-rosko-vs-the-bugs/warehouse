import strutils
import osproc
import os
import strformat

import tool_config
import git_commands

type
  RepoList = object
    root_location:string
    repo_name:seq[string]
    repo_remote:seq[string]


proc GetRepos(manifest_location:string, manifest_file_name:string = "manifest"):RepoList=
  result = RepoList(root_location:manifest_location)

  var ManifestFile = open(manifest_location & "/" & manifest_file_name)
  if ManifestFile == nil:
    raiseAssert(fmt"No manifest file in {manifest_location}")
  var line:string
  var line_split:seq[string]
  while readLine(ManifestFile,line):
    line_split = line.split("=",1)
    if line_split.len() < 2:
      stderr.write(fmt"Manifest corrupted at {manifest_location}/{manifest_file_name}\n")
    else:
      result.repo_name.add(line_split[0])
      result.repo_remote.add(line_split[1])
  return result




proc CheckoutRepoBreanch(repo,branch,warehouse:string):int=
  return ExecGitCommandAtDIr(warehouse & "/" & repo, fmt"checkout -c {branch}")

proc SyncRepoSpecfic(Warehouse,RootName:string,clean:int=0):int=
  if clean == 1:
    return ExecCommandSeq(Warehouse & "/" & RootName,SyncRepoSeq)
  else:
    return ExecCommandSeq(Warehouse & "/" & RootName,SyncRepoStash)



proc SyncRepoAll(warehouse:string,clean:int =0):int=
  var repos = GetRepos(warehouse & "/" & "manifest")
  for i in 0..<repos.repo_name.len():
    if SyncRepoSpecfic(warehouse,repos.repo_name[i],clean) > 0:
      raiseAssert("Git command failed ")

proc RepoClean(warehouse):bool=
  return false

#proc RepoStat(manifest_location:string, manifest_file_name:string = "manifest"):int=
#  var op_res:int
#  var List:RepoList= GetRepos(manifest_location,manifest_file_name)
#  var string
#  for i in 0..<List.repo_name.len():
#    execProcesses("git","",@[fmt"--git-dir={manifest_location}/{List.repo_name[i]}","status"])
#    if 
#    i
