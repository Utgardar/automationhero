# Terraform code

## Solution details

Autoscaling group will start new EC2 instance with page in case if running instance will be removed for any reason.

Page will be accessible only from instance where this code was applied.

Documentation for Terraform code was generated with local pre-commit hook by [Anton Babenko](https://github.com/antonbabenko/pre-commit-terraform)

## Howto

To apply configuration you need to:

* change folder to `terraform`
* run `terraform init` to get providers dependencies
* run `terraform apply` to create resources

After terraform will finish apply, it returns URL to access page.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.asg_helloWorld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_elb.web_elb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elb) | resource |
| [aws_launch_template.helloWorld](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.task_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_ami.amazon-linux-2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_ami.ubuntu](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_subnet_ids.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnet_ids) | data source |
| [aws_vpc.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [http_http.my_public_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [template_file.helloWorld](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app"></a> [app](#input\_app) | Contains application name | `string` | `"helloWorld"` | no |
| <a name="input_env"></a> [env](#input\_env) | Contains environment label where app is deployed | `string` | `"dev"` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Sets amount of desired instances in autoscaling group | `number` | `1` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | Sets instance type for application | `string` | `"t2.micro"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region used to deploy application | `string` | `"eu-central-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_vpc_id"></a> [default\_vpc\_id](#output\_default\_vpc\_id) | Default VPC ID |
| <a name="output_deployed_service_dns"></a> [deployed\_service\_dns](#output\_deployed\_service\_dns) | Returns URL to access application (DNS name) |
| <a name="output_local_ip"></a> [local\_ip](#output\_local\_ip) | Returns runner IP address which will be specified in security group |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
