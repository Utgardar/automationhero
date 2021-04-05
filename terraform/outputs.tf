output "default_vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}

output "local_ip" {
  description = "Returns runner IP address which will be specified in security group"
  value       = local.ifconfig_co_json.ip
}

output "deployed_service_dns" {
  description = "Returns URL to access application (DNS name)"
  value       = "http://${aws_elb.web_elb.dns_name}"
}
