Sample configuration

Source:
1) Clone the repo and enter the source directory.
2) Add the repos you want to bundle into the _repo_source_list.txt file
3) run _create-git-bundles.sh
4) A _bundles folder will be created.  Transfer the _bundle folder and _repo_source_list.txt file to the destination.

Destination:
1) Clone the repo and enter the destination directory.
2) Place the _bundle folder into the destination folder
3) Add the destination repos into the _repo_destination_list.txt file.  Currently an underscore is used for breaking up names.  Your destination repo name should look like so: <sourceaccount>_<reponame>.git
4) Run _update-mirrors.sh