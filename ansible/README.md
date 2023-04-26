# aws-play ansible stuff

## Install Ansible and others on your machine

```bash
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible python3-pip -y
```

Ensure boto3 is installed (for Ansible)

```bash
python3 -m pip install boto3
```

## Check installed Ansible collections

```bash
ansible-galaxy collection list
```

## Install amazon.aws.ec2_instance_info module

> Should be done only if `amazon.aws` is not present

```bash
ansible-galaxy collection install amazon.aws
```

## Run the installation of Docker on our EC2 instance

```bash
ansible-playbook 00_install_docker.yml --key-file=~/.ssh/PlayAWSKeyPair.pem
```
