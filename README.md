# terraform-template

This repository is used as a template for terraform directory structure.

The following configuration holds the basic configuration, so please use this repository as a base for expansion.
For your reference, here is a description of how to deploy resources in each directory.

Please add additional resources if you need them.

```
workspaces/
├── account (iam)
├── computing (ECS, RDS, Redis)
├── deployment-pipeline (CodeDeploy, CodePipeline)
├── modules
├── networking (VPC, ALB)
├── security (KMS, ACM)
└── storage (S3)

```
