# Summary
This tool is used to create git bundles which can easily be pushed to a private git server.

## Usage

### Creating the git bundles:

* Clone the repo and enter the source directory.
* Add the repos you want to bundle into the _\_repo\_source\_list.txt_ file
* Run _\_create-git-bundles.sh_
* A _\_bundles_ folder will be created.  Transfer the _\_bundles_ folder and _\_repo\_source\_list.txt_ file to the destination.

### Deploying the git bundles:

* Clone the repo and enter the destination directory.
* Place the _\_bundle_ folder into the destination folder
* Add the destination repos into the _\_repo\_destination\_list.txt_ file.
* **NOTE:** Currently an underscore is used for breaking up names.  Your destination repo name should look like:  `https://gitserver.com/moskey71/<sourceaccount>_<reponame>.git` or `git@gitserver.com:moskey71/<sourceaccount>_<reponame>.git`  For example, a source of `https://github.com/hashicorp/terraform.git` would have a destination format like `https://gitserver.com/moskey71/hashicorp_terraform.git`
or
`git@gitserver.com:moskey71/hashicorp_terraform.git`
Personally, I like to keep my mirrors organized together, so I use a group.  Using SSH, it would like like `git@gitserver.com:moskey71/mirror-groups/hashicorp_terraform.git`
* Run _\_update-mirrors.sh_

