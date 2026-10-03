# Infrastructure

CloudFormation is split by responsibility so each layer can be reviewed and changed independently.

- `network.yaml`: VPC, public/private subnets, route tables, NAT gateways and security groups.
- `database.yaml`: private Multi-AZ PostgreSQL and Secrets Manager credentials.
- `ecs.yaml`: ECR repositories, ECS/Fargate services, ALB, CloudWatch logs and service scaling.
- `ec2.yaml`: alternative non-containerized EC2/Auto Scaling deployment.
- `monitoring.yaml`: CloudWatch alarms and log metric filter.
- `cicd.yaml`: AWS CodeBuild project used by the GitHub Actions orchestration path.
- `github-oidc.yaml`: IAM trust policy for GitHub Actions OIDC.

The application pipeline never calls CloudFormation. The infrastructure pipeline owns CloudFormation changes.

No AWS deployment is required for code review. The templates are provided as the deployable implementation and can be validated with `cfn-lint` in GitHub Actions.
