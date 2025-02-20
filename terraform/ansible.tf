# Resources to configure the server and deploy applications using Ansible

# Installation of Ansible if it is not installed
resource "null_resource" "install_ansible" {
  provisioner "local-exec" {
    command = <<EOT
            if ! command -v ansible-playbook &> /dev/null; then
                echo "Ansible not found. Installing Ansible..."
                if command -v apt-get &> /dev/null; then
                    sudo apt-get update
                    sudo apt-get install -y ansible
                elif command -v yum &> /dev/null; then
                    sudo yum install -y ansible
                elif command -v brew &> /dev/null; then
                    brew install ansible
                else
                    echo "Unsupported package manager. Please install Ansible manually."
                    exit 1
                fi
            else
                echo "Ansible is already installed."
            fi
        EOT
  }
}

# Add the server's IP to the SSH known_hosts file
resource "null_resource" "configure_ssh_known_hosts" {
  depends_on = [
    yandex_compute_instance.server,
  ]

  provisioner "local-exec" {
    command = "../scripts/add-known-hosts.sh ${yandex_compute_instance.server.network_interface[0].nat_ip_address}"
  }
}

# Generate the Ansible inventory file dynamically
resource "local_file" "generate_ansible_inventory" {
  content = templatefile("${path.module}/templates/inventory.tftpl", {
    server_ip          = yandex_compute_instance.server.network_interface[0].nat_ip_address,
    ssh_private_key    = var.SSH_PRIVATE_KEY_PATH,
    ansible_user       = var.ANSIBLE_USER,
    ansible_connection = var.ANSIBLE_CONNECTION
  })
  filename = "../ansible/inventory"
}

# Run the Ansible playbook to provision the server
resource "null_resource" "run_ansible_playbook" {
  depends_on = [
    yandex_compute_instance.server,
    local_file.generate_ansible_inventory,
    null_resource.configure_ssh_known_hosts,
    null_resource.install_ansible,
  ]

  provisioner "local-exec" {
    command = "ansible-playbook --become --become-user root --become-method sudo -i ../ansible/inventory ../ansible/nextcloud.yml"
  }
}

# Variables
variable "ANSIBLE_USER" {
  type        = string
  description = "The user for Ansible to connect as"
  default     = "ubuntu"
}

variable "ANSIBLE_CONNECTION" {
  type        = string
  description = "The connection type for Ansible (e.g., ssh)"
  default     = "ssh"
}