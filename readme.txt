$ terraform workspace new dev
Created and switched to workspace "dev"!
You're now on a new, empty workspace. Workspaces isolate their state, so if you run "terraform plan" Terraform will not see any existing state for this configuration.
$ terraform workspace list
  default
* dev

$ terraform workspace select dev
...
$ terraform plan -var-file=env/dev/network.tfvars
...
$ terraform apply -var-file=env/dev/network.tfvars
...