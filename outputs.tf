output "public_ip" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.web.*.public_ip
}

output "public_ip_alb" {
  description = "List of public IP addresses assigned to the instances, if applicable"
  value       = aws_instance.alb.*.public_ip
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances, if applicable"
  value       = aws_instance.web.*.private_ip
}

output "p_ip1"{

  value = aws_instance.web[0].private_ip
}
output "p_ip2"{

  value = aws_instance.web[1].private_ip
}