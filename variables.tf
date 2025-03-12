variable "server_name" {
  description = "Server names"
  default     = [
    {
       name = "control-node"
    },
    {  
       name = "client1"
    },
    { 
       name = "client2"
    },
  ]
}

variable "ssh_public_key" {
  description = "The public SSH key to use for the EC2 instance."
  type        = string
}

variable "bkt" {
  description = "The public SSH key to use for the EC2 instance."
  type        = string
}

variable "user_data" {
  type = map(string)
  default = {
    "0" = <<-EOT
      #!/bin/bash
      hostnamectl set-hostname ansible-master
      pip3 install ansible
      sudo useradd -s /bin/bash automate
      sudo usermod -G wheel automate
    EOT
    "1" = <<-EOT
      #!/bin/bash
      hostnamectl set-hostname ansible-client1
      sudo useradd -s /bin/bash automate
      sudo usermod -G wheel automate
      useradd client1_user
    EOT
    "2" = <<-EOT
      #!/bin/bash
      hostnamectl set-hostname ansible-client2
      sudo useradd -s /bin/bash automate
      sudo usermod -G wheel automate
      useradd client2_user
    EOT
  }
}
