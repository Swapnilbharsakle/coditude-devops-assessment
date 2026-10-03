# Architecture

The target design uses an AWS VPC with public and private subnets across two Availability Zones. The frontend is a Next.js application, the backend is Python, and PostgreSQL is hosted on Amazon RDS.

Containerized deployment targets ECS/Fargate. A separate EC2-based approach is provided for non-containerized deployment.

CloudWatch provides infrastructure/application monitoring. IAM provides access control and Secrets Manager stores sensitive application configuration.
