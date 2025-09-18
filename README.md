# TERRAFORM & ANSIBLE
Ceci est un exemple de définition d'infrastructure cloud aws avec Terraform et Ansible

######################################################################################
###########  Structure du projet:  ###########

```
terraform & ansible
├─ ansible
│  ├─ group_vars
│  │  └─ all
│  │     ├─ vault.yml
│  │     └─ vault_cmd.txt
│  ├─ inventories
│  │  └─ hosts
│  ├─ playbooks
│  │  ├─ configure-webserver.yml
│  │  ├─ roles
│  │  │  └─ common
│  │  │     ├─ tasks
│  │  │     │  └─ main.yml
│  │  │     └─ templates
│  │  │        └─ jail.local.j2
│  │  ├─ site.yml
│  │  └─ templates
│  │     ├─ index.html.j2
│  │     └─ nginx-site.conf.j2
│  └─ vault.yml
├─ README.md
├─ scripts
│  ├─ deploy.sh
│  └─ validate.sh
└─ terraform
   ├─ .terraform
   │  ├─ providers
   │  │  └─ registry.terraform.io
   │  │     └─ hashicorp
   │  │        ├─ aws
   │  │        │  └─ 5.100.0
   │  │        │     └─ windows_386
   │  │        │        ├─ LICENSE.txt
   │  │        │        └─ terraform-provider-aws_v5.100.0_x5.exe
   │  │        ├─ azurerm
   │  │        │  └─ 3.117.1
   │  │        │     └─ windows_386
   │  │        │        ├─ LICENSE.txt
   │  │        │        └─ terraform-provider-azurerm_v3.117.1_x5.exe
   │  │        ├─ google
   │  │        │  └─ 4.85.0
   │  │        │     └─ windows_386
   │  │        │        └─ terraform-provider-google_v4.85.0_x5.exe
   │  │        └─ random
   │  │           └─ 3.7.2
   │  │              └─ windows_386
   │  │                 ├─ LICENSE.txt
   │  │                 └─ terraform-provider-random_v3.7.2_x5.exe
   │  └─ terraform.tfstate
   ├─ .terraform.lock.hcl
   ├─ backend.tf
   ├─ create-backend.sh
   ├─ dev.tfvars
   ├─ environments
   │  ├─ dev
   │  ├─ prod
   │  └─ staging
   ├─ infrastructure.tf
   ├─ main.tf
   ├─ modules
   ├─ outputs.tf
   ├─ prod.tfvars
   ├─ README.md
   ├─ scripts
   │  ├─ deploy.sh
   │  └─ validate.sh
   ├─ setup-backend.sh
   ├─ terraform.tf
   ├─ user_data.sh
   ├─ variables.tf
   └─ versions.tf

```

#######Commandes utiles:############


1. Déployer l'infrastructure avec Terraform :

        cd terraform

        # Initialisation
        terraform init

        # Vérification de la syntaxe
        terraform validate

        # Planification (voir ce qui sera créé)
        terraform plan -var="db_password=VotreMotDePasse123!"

        # Application (création réelle)
        terraform apply -var="db_password=VotreMotDePasse123!"


2. Récupérer les outputs pour Ansible :

        cd ../ansible

        # Tester la connexion
        ansible -i inventories/hosts webservers -m ping

        # Lancer le playbook
        ansible-playbook -i inventories/hosts playbooks/site.yml --ask-vault-pass


3. Configurer avec Ansible :
        cd ../ansible

        # Tester la connexion
        ansible -i inventories/hosts webservers -m ping

        # Lancer le playbook
        ansible-playbook -i inventories/hosts playbooks/site.yml --ask-vault-pass


Ou utiliser le script de déploiement  :

        chmod +x ../scripts/deploy.sh
        ../scripts/deploy.sh
