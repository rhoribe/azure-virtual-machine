locals {
  linux_vms   = [for vm in var.vm : vm if lower(vm.os) == "linux" && vm.create == true]
  windows_vms = [for vm in var.vm : vm if lower(vm.os) == "windows" && vm.create == true]
}