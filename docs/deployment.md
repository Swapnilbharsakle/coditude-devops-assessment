# Deployment Flow

## Application changes
Application-only changes trigger the application workflow. The workflow builds/tests the application and deploys the application artifact. It does not execute CloudFormation.

## Infrastructure changes
Infrastructure-only changes trigger the infrastructure workflow. CloudFormation templates are linted/validated and then deployed separately.
