import os
import strformat

import tool_config
import git_commands

type
  RepoList = object
    root_location:string
    repo_name:seq[string]


###experimental
proc GetRemoteManifest(web_location,target_directory:string):int=
  return 0


proc GetRepos(manifest_location:string):RepoList=
  result = RepoList()


proc GetRepoBranches(RepoLocation:string):seq[string]=
  

proc CheckoutRepoBreanch(repo,branch,warehouse:string):int=
  return ExecGitCommandAtDIr(warehouse & "/" & repo, fmt"checkout -c {branch}")

proc SyncRepoSpecfic(Warehouse,RootName,Branch:string):int=
  return ExecCommandSeq(Warehouse & "/" & RootName,GetCommandSeqForBranch(Branch))



proc SyncRepoAll(warehouse:string):int=
  return 0



proc RepoClean(warehouse):bool=
  false
