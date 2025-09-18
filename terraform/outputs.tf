# Outputs réseau
output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs des subnets publics"
  value       = aws_subnet.public[*].id
}

# Outputs des instances
output "instance_ids" {
  description = "IDs des instances EC2"
  value       = aws_instance.web_server[*].id
}

output "instance_public_ips" {
  description = "Adresses IP publiques des instances"
  value       = aws_instance.web_server[*].public_ip
  sensitive   = false
}

# Outputs du load balancer
output "load_balancer_dns" {
  description = "DNS du load balancer"
  value       = aws_lb.main.dns_name
}

output "load_balancer_url" {
  description = "URL complète de l'application"
  value       = "http://${aws_lb.main.dns_name}"
}

# Outputs de la base de données (sensibles)
output "database_endpoint" {
  description = "Endpoint de la base de données"
  value       = aws_db_instance.postgres.endpoint
  sensitive   = true
}

# Outputs pour Ansible
output "ansible_inventory" {
  description = "Inventaire pour Ansible"
  value = {
    webservers = aws_instance.web_server[*].public_ip
    database   = [aws_db_instance.postgres.endpoint]
  }
}
