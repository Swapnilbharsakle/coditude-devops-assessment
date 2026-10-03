# Coditude DevOps Assessment

Production-oriented reference implementation for:

- Next.js frontend
- Python FastAPI backend
- PostgreSQL database
- AWS CloudFormation infrastructure
- GitHub Actions CI/CD
- AWS CodeBuild integration
- Containerized and non-containerized deployment models

> The repository is designed as a deployable implementation. AWS resources do not need to be provisioned for code review; the application can be exercised locally with Docker Compose.

## Architecture

See [`docs/architecture.md`](docs/architecture.md) and [`architecture/architecture.svg`](architecture/architecture.svg).

### Containerized

`Route 53 → CloudFront → ALB → ECS/Fargate → RDS PostgreSQL`

### Non-containerized

`Route 53 → ALB → EC2 Auto Scaling Groups → RDS PostgreSQL`

## Repository structure

```text
frontend/                         Next.js application
backend/                          FastAPI application
infra/network.yaml                VPC, subnets, NAT and security groups
infra/database.yaml               RDS PostgreSQL + Secrets Manager
infra/ecs.yaml                    ECR + ECS/Fargate + ALB + scaling
infra/ec2.yaml                    Alternative EC2 deployment
infra/monitoring.yaml             CloudWatch alarms/metrics
infra/cicd.yaml                   AWS CodeBuild project
infra/github-oidc.yaml            GitHub Actions OIDC IAM role
.github/workflows/application.yml Application CI/CD
.github/workflows/infrastructure.yml Infrastructure CI/CD
.github/workflows/non-containerized-deployment.yml EC2 app deployment
scripts/deploy-ecs.sh             ECS rolling deployment helper
docker-compose.yml                Local frontend/backend/PostgreSQL stack
docs/                             Architecture, deployment, security, rollback
```

## Local validation

### Full application

```bash
docker compose up --build
```

Endpoints:

- Frontend: `http://localhost:3000`
- Backend health: `http://localhost:8000/health`
- Backend info: `http://localhost:8000/api/info`
- Database check: `http://localhost:8000/api/db-check`

### Backend only

```bash
cd backend
python -m venv .venv
# Windows PowerShell: .venv\\Scripts\\Activate.ps1
pip install -r requirements.txt
uvicorn app:app --reload --port 8000
```

## CI/CD separation

Application changes under `frontend/` or `backend/` trigger `application.yml`.

That workflow:

1. Validates Python syntax.
2. Builds both Docker images.
3. Optionally triggers AWS CodeBuild.
4. Optionally pushes immutable Git SHA images to ECR.
5. Optionally updates ECS task definitions/services.
6. **Does not run CloudFormation.**

Infrastructure changes under `infra/` trigger `infrastructure.yml`.

That workflow:

1. Runs `cfn-lint` against the templates.
2. Optionally deploys network/database/ECS/monitoring/CodeBuild stacks.
3. Can optionally deploy the EC2 alternative.

This separation directly implements the assessment requirement that application-only changes must not redeploy or modify infrastructure.

## Security

- Private subnets for application and database workloads.
- RDS encryption and automated backups.
- Secrets Manager for PostgreSQL credentials.
- IAM least privilege for ECS and CI/CD.
- GitHub Actions uses OIDC instead of long-lived AWS access keys.
- ECR image scanning and immutable tags.
- No credentials are stored in source code.

See [`docs/security.md`](docs/security.md).

## Rollback

Application images are tagged with the Git commit SHA. ECS can roll back to a previous task-definition revision/image tag.

Infrastructure changes are managed through CloudFormation and can be reviewed through Change Sets before execution.

See [`docs/rollback.md`](docs/rollback.md).

## Assessment requirement mapping

| Requirement | Implementation |
|---|---|
| AWS networking | `infra/network.yaml` |
| PostgreSQL | `infra/database.yaml` |
| Containerized deployment | `infra/ecs.yaml` |
| Non-containerized deployment | `infra/ec2.yaml` |
| CloudFormation | `infra/*.yaml` |
| GitHub Actions | `.github/workflows/` |
| AWS-native CI/CD | `infra/cicd.yaml` / CodeBuild |
| Application/infra separation | `application.yml` vs `infrastructure.yml` |
| Secrets | Secrets Manager + IAM |
| Monitoring | `infra/monitoring.yaml` + ECS CloudWatch logs |
| Architecture diagram | `architecture/architecture.svg` |
| Documentation | `docs/` |
