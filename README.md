# Nextcloud Deployment with Terraform and Ansible

This project automates the deployment of Nextcloud on a Yandex Cloud virtual machine using Terraform for infrastructure provisioning and Ansible for configuration management. The setup ensures a seamless and repeatable deployment process.

---

## Project Setup
### 1. Clone the Repository:
```bash
git https://github.com/soundbanana/nextcloud-deployment-service.git
cd nextcloud-deployment-service
```

### 2. Initialize Terraform:
Run the following command to initialize Terraform and download the required providers:
```bash
terraform init
```

### 3. Run the following command to get your Cloud ID
```bash
yc resource-manager cloud list
```

### 4. Run the following command to get keys for your Yandex Cloud Service Account:
```bash
yc iam key create --service-account-name {your-sa-name} --output ../path/to/keys.json

```

### 5. Configure Variables:
Update the terraform.tfvars file with your Yandex Cloud credentials and other required variables. Example:
```hcl
CLOUD_ID = "your-cloud-id"
FOLDER_ID = "your-folder-id"
SERVICE_ACCOUNT_KEY_FILE_PATH = "../path/to/keys.json"
```

## Deployment Instructions
### 1. Apply the Terraform Configuration:
Deploy the infrastructure and configure the server using Ansible:
```bash
cd terraform
terraform init
terraform apply
```
Terraform will:
- Provision a virtual machine on Yandex Cloud.
- Automatically install Ansible if it is not already installed.
- Add the server's IP address to the SSH known_hosts file.
- Run the Ansible playbook to install and configure Nextcloud.

### 2. Verify the Output:
After the deployment is complete, Terraform will output the URL and DNS address of the server. Example:
```bash
dns = "http://project.vvot39.itiscl.ru./nextcloud/index.php"
url = "http://130.193.59.233/nextcloud/index.php"
```

## Destroying Resources
To tear down the infrastructure and remove all resources, run:
```bash
terraform destroy
```

This will:
- Delete the virtual machine.
- Remove all associated resources (e.g., network, disk).

## Ansible Installation Guide

If Ansible is not installed, the Terraform script will attempt to install it automatically. If the automatic installation fails, you can install Ansible manually using the appropriate package manager for your system.

---

### **Ubuntu/Debian**

Run the following commands to install Ansible on Ubuntu or Debian-based systems:

```bash
sudo apt update
sudo apt install ansible -y
```

### **CentOS/RHEL**

Run the following commands to install Ansible on CentOS or RHEL-based systems:

```bash
sudo yum install ansible -y
```

### **macOS**

If you are using macOS, you can install Ansible via Homebrew:

```bash
brew install ansible
```

## Notes
- Automatic Ansible Installation: The Terraform script includes a step to automatically install Ansible if it is not already present on your system.

- Retry Mechanism: The script includes a retry mechanism for adding the server to the known_hosts file. If it fails, simply re-run terraform apply.

- DNS Configuration: If you are using a custom DNS, ensure that the DNS records are correctly configured before accessing Nextcloud.

## Contributing
If you would like to contribute to this project, feel free to open an issue or submit a pull request. Your contributions are welcome!

## Screenshots: Running Server
![](/screenshots/nextcloud-configs.jpg)
![](/screenshots/apache-status.jpg)
![](/screenshots/running-server.jpg)
