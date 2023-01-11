variable "az_source_image" {
  type = object({
    os_type         = string
    image_publisher = string
    image_offer     = string
    image_sku       = string
    vm_size         = string
  })
  default = {
    os_type         = "Linux"
    image_publisher = "RedHat"
    image_offer     = "RHEL"
    image_sku       = "91-gen2"
    vm_size         = "Standard_DS2_v2"
  }
  # az vm image list  --offer RHEL --publisher RedHat --all --output table
}

variable "az_build" {
  type = object({
    build_resource_group_name              = string
    virtual_network_resource_group_name    = string
    virtual_network_name                   = string
    virtual_network_subnet_name            = string
    private_virtual_network_with_public_ip = bool
  })
  default = {
    build_resource_group_name              = "rg-image-builder"
    virtual_network_resource_group_name    = "rg-image-builder-network"
    virtual_network_name                   = "vnet-image-builder-network"
    virtual_network_subnet_name            = "Build"
    private_virtual_network_with_public_ip = true
  }
}

variable "az_target_image" {
  type = object({
    managed_image_resource_group_name = string
    managed_image_name_prefix         = string
  })
  default = {
    managed_image_resource_group_name = "rg-image-builder-images"
    managed_image_name_prefix         = "img-gha-runner-ansible"
  }
}