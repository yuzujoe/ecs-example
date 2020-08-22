# ecs-example

This is a sample repository for creating an environment to run ECS.

The directory structure is as follows

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

You can use your favorite bucket name to manage the state, since the terraform remote state is managed by s3.

## Usage

```bash
export AWS_PROFILE=<your profile>
```

Go to the target directory

```bash
cd workspace/<target directory>
```

create or update resources

```bash
terraform init #When using it for the first time

terraform plan

terraform apply
```

delete resources

```bash
terraform destroy
```

format

```bash
terraform fmt
```

validation

```bash
terraform validate
```
