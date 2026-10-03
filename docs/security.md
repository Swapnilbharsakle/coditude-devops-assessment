# Security

- Use IAM roles instead of long-lived access keys where possible.
- Store database/application secrets in AWS Secrets Manager.
- Keep RDS in private subnets.
- Restrict security groups to required ports and sources.
- Keep secrets out of source control and CI logs.
