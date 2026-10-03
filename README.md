# Coditude DevOps Assessment

Production-oriented AWS implementation for:
- Next.js frontend
- Python FastAPI backend
- PostgreSQL database

## Deployment approaches
1. Containerized: Docker -> Amazon ECR -> ECS/Fargate
2. Non-containerized: EC2-based application deployment

## Infrastructure as Code
AWS CloudFormation. Application and infrastructure deployment workflows are intentionally separated.

## Repository layout
- `frontend/` - Next.js frontend
- `backend/` - FastAPI backend
- `infra/` - CloudFormation templates
- `.github/workflows/` - application and infrastructure pipelines
- `docs/` - architecture, deployment, security and rollback notes

## Local development
### Backend
```bash
cd backend
python -m venv .venv
# Windows PowerShell: .venv\\Scripts\\Activate.ps1
pip install -r requirements.txt
uvicorn app:app --reload --port 8000
```

### Frontend
```bash
cd frontend
npm install
npm run dev
```

The frontend expects the API URL in `NEXT_PUBLIC_API_URL` and defaults to `http://localhost:8000`.

> Cloud deployment is intentionally built in small, testable steps. Do not deploy infrastructure until the local application and CloudFormation templates have been validated.
