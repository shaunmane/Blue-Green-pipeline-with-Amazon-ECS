# AWS DevOps Blue/Green Pipeline Workshop (Terraform IaC)

This repository contains the Infrastructure as Code (IaC) used to provision and manage resources for the "[Building your first DevOps Blue/Green pipeline with Amazon ECS](https://catalog.us-east-1.prod.workshops.aws/workshops/4b59b9fb-48b6-461c-9377-907b2e33c9df/en-US)" workshop. This workshop provides hands-on experience in implementing modern deployment strategies on AWS.

The workshop guides participants through the process of setting up a robust and automated Blue/Green deployment pipeline for applications hosted on Amazon Elastic Container Service (ECS). By leveraging Blue/Green deployments, we ensure zero downtime, rapid rollbacks, and safer software releases. All the AWS resources required for this workshop are provisioned and managed using Terraform, demonstrating best practices for Infrastructure as Code.

## Table of Content
- [Amazon ECS with EC2](#amazon-ecs-with-ec2)
  * [Architectural Diagram](#architectural-diagram)
  * [Services Used](#services-used)
- [Amazon ECS with Fargate](#amazon-ecs-with-fargate)

## Amazon ECS with EC2

### Architectural Diagram

![diagram](architecture-ecs-ec2.png)

### Services Used

- **AWS IAM**: For permissions to allow a role to execute the infrastructure code.
- **Amazon ECS**: 
- **Amazon EC2**: 
- **Amazon Aurora**: 
- **Amazon ECR**: 
- **Amazon S3**: 
- **Amazon Cloudwatch**: 

## Amazon ECS with Fargate