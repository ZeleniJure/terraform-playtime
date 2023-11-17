# Basic folder structure for terraform
We assume that state storage bucket and IAM for basic access are already there.

Root folder contains common modules and 2 separate environments, production and staging. Both are using the provided module.
Each environment consists of a set of applications (or stacks?) deployed there. The only usable one is the `awsomeapp`.

Approximate CI workflow would be:
- for each application / only for changed apps / external provider such as env0, ...
- check gcloud cli / terraform cli versions
- run a static check or perhaps some opa rules
- configure credentials (gcloud login)
- retrieve any secrets needed (for various apps)
- run infracost
- run terraform plan / apply with correct backends (and paths) set
- advanced: trigger build of a different app (e.g. usually when other apps use remote state, and need to be updated)

## Links
- [production app](./production/awsomeapp/README.md)
- [infra module](./module-awsome-app/README.md)
- [tfvars possible usage](./production/awsomeapp/env.tfvars)
- [thoughts about TF backend](./production/awsomeapp/backend.tf)

## Quick Start
```bash
cd production/awsomeapp
terraform init
terraform validate
```
