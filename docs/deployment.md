# Deployment Guide

The assessment supports two application deployment models. Neither model requires the evaluator to run the infrastructure during code review; the CloudFormation and pipeline definitions are deployable artifacts.

## 1. Local validation

```bash
docker compose up --build
```

Then verify:

- Frontend: `http://localhost:3000`
- Backend health: `http://localhost:8000/health`
- Backend API: `http://localhost:8000/api/info`
- Database check: `http://localhost:8000/api/db-check`

## 2. Containerized AWS deployment

The intended flow is:

1. Infrastructure pipeline provisions the network, PostgreSQL, ECS cluster, ALB, ECR and supporting IAM/logging resources.
2. Application pipeline builds the frontend/backend images and publishes immutable Git SHA tags to ECR.
3. The application deployment updates ECS task definitions/services.
4. ECS performs a rolling deployment and the ALB health checks determine task readiness.

Application-only changes never execute CloudFormation.

## 3. Non-containerized AWS deployment

`infra/ec2.yaml` provides the alternative EC2/Auto Scaling deployment model. It installs Node.js/Python on Amazon Linux and starts the applications from versioned artifacts.

## 4. Environments

The same templates are parameterized with `AppEnvironment` (`dev`, `staging`, `prod`). GitHub Environments can provide environment-specific AWS role ARNs and approval gates.
