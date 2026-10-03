# Rollback Strategy

## Application rollback

Application images use immutable Git SHA tags. A failed release can be rolled back by redeploying the previous known-good task definition/image tag. ECS keeps the previous task definition revision available for this purpose.

## Infrastructure rollback

Infrastructure changes are managed by CloudFormation. The deployment workflow validates templates before deployment and CloudFormation maintains stack events and change history. Riskier changes should be reviewed through a Change Set before execution.

## Database

RDS uses automated backups and a snapshot deletion policy. Destructive schema changes should be handled through versioned migrations and backward-compatible application releases rather than relying on infrastructure rollback.
