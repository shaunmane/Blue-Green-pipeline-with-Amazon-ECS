<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.13.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ami_id"></a> [ami\_id](#input\_ami\_id) | DB instance type | `string` | `"ami-0c02fb55956c7d316"` | no |
| <a name="input_aurora_engine_version"></a> [aurora\_engine\_version](#input\_aurora\_engine\_version) | Engine version for aurora db | `string` | `"14.5"` | no |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region used for the services | `string` | n/a | yes |
| <a name="input_azs_use1"></a> [azs\_use1](#input\_azs\_use1) | Availability Zones for the region | `list(string)` | n/a | yes |
| <a name="input_db_instance"></a> [db\_instance](#input\_db\_instance) | DB instance type | `string` | `"db.t4g.medium"` | no |
| <a name="input_ec2_instance"></a> [ec2\_instance](#input\_ec2\_instance) | ECS asg instance type | `string` | `"t3.large"` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | Engine type for the db | `string` | `"aurora-postgresql"` | no |
| <a name="input_private_subnet_cidrs"></a> [private\_subnet\_cidrs](#input\_private\_subnet\_cidrs) | CIDR ranges for the private subnets | `list(string)` | n/a | yes |
| <a name="input_public_subnet_cidrs"></a> [public\_subnet\_cidrs](#input\_public\_subnet\_cidrs) | CIDR ranges for the private subnets | `list(string)` | n/a | yes |
| <a name="input_rds_aurora_name"></a> [rds\_aurora\_name](#input\_rds\_aurora\_name) | Name of the Aurora PostgreSQL database | `string` | `"tripmgmtdb-cluster"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | Name of the container repository | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet IDs in the default VPC | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID of the default VPC | `string` | n/a | yes |

## Outputs

No outputs.

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs_asg](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/autoscaling_group) | resource |
| [aws_ecr_repository.tripmgmtdemo](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/ecr_repository) | resource |
| [aws_ecs_capacity_provider.asg_cp](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.tripmgmt_cluster](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.ecs_cp_attach](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.ecs_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecsInstanceRole](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/iam_role) | resource |
| [aws_iam_role.ecsTaskExecutionRole](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/iam_role) | resource |
| [aws_iam_service_linked_role.AWSServiceRoleForAutoScaling](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/iam_service_linked_role) | resource |
| [aws_iam_service_linked_role.AWSServiceRoleForECS](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/iam_service_linked_role) | resource |
| [aws_launch_template.asg_lt](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/launch_template) | resource |
| [aws_lb.app_alb](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/lb) | resource |
| [aws_lb_listener.port_8080_listener](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/lb_listener) | resource |
| [aws_lb_listener.port_80_listener](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.alb_target_80](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.alb_target_8080](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/lb_target_group) | resource |
| [aws_rds_cluster.aurora_postgres](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/rds_cluster) | resource |
| [aws_rds_cluster_instance.aurora_postgres_instance](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/rds_cluster_instance) | resource |
| [aws_rds_subnet_group.aurora_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/rds_subnet_group) | resource |
| [aws_s3_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.tf_state_versioning](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb_sg](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/security_group) | resource |
| [aws_security_group.aurora_sg](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/security_group) | resource |
| [aws_security_group.ecs_container_sg](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/security_group) | resource |
| [aws_ssm_parameter.aurora_password](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/ssm_parameter) | resource |
| [aws_vpc_security_group_ingress_rule.allow_8080_port](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_8080_port_ec2](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_80_port](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.allow_80_port_ec2](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/resources/vpc_security_group_ingress_rule) | resource |
| [random_password.db_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/data-sources/caller_identity) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/data-sources/partition) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/data-sources/region) | data source |
| [aws_subnets.default_vpc_subnets](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/data-sources/subnets) | data source |
| [aws_vpc.default_vpc](https://registry.terraform.io/providers/hashicorp/aws/6.13.0/docs/data-sources/vpc) | data source |
| [http_http.my_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
<!-- END_TF_DOCS -->