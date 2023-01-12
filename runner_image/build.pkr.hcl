packer {
  required_plugins {
    azure-arm = {
      source  = "github.com/hashicorp/azure"
      version = "~> 1.3.1"
    }
  }
}

source "azure-arm" "runner" {
  use_azure_cli_auth = true

  # Temporary OS information
  os_type = var.az_source_image.os_type

  image_publisher = var.az_source_image.image_publisher
  image_offer     = var.az_source_image.image_offer
  image_sku       = var.az_source_image.image_sku

  vm_size = var.az_source_image.vm_size

  # Temporary Environment information
  build_resource_group_name              = var.az_build.build_resource_group_name
  virtual_network_resource_group_name    = var.az_build.virtual_network_resource_group_name
  virtual_network_name                   = var.az_build.virtual_network_name
  virtual_network_subnet_name            = var.az_build.virtual_network_subnet_name
  private_virtual_network_with_public_ip = var.az_build.private_virtual_network_with_public_ip

  # Output image information
  managed_image_resource_group_name = var.az_target_image.managed_image_resource_group_name
  managed_image_name                = "${var.az_target_image.managed_image_name_prefix}_${formatdate("YYYY-MM-DD_hh-mm-ss", timestamp())}"
}

build {
  name    = "gha-runner-ansible"
  sources = ["source.azure-arm.runner"]

  provisioner "ansible" {
    command              = "./command_ansible.sh"
    playbook_file        = "./ansible/playbook.yml"
    galaxy_file          = "./ansible/requirements.yml"
    galaxy_force_install = true
    sftp_command         = "/usr/libexec/openssh/sftp-server -e"
    user                 = "packer"

    ansible_env_vars = [
      "ANSIBLE_DEPRECATION_WARNINGS=False",
      "ANSIBLE_HOST_KEY_CHECKING=False",
      "ANSIBLE_NOCOLOR=True",
      "ANSIBLE_NOCOWS=1"
    ]

    # extra_arguments = ["-vvv"]
    ansible_ssh_extra_args = ["-o HostKeyAlgorithms=+ssh-rsa -o PubkeyAcceptedKeyTypes=+ssh-rsa -o IdentitiesOnly=yes"]
    # extra_arguments = ["--scp-extra-args", "'-O'"]
  }
}