# Rollback Strategy

Application rollback uses the previous known-good application artifact/image.

Infrastructure changes should use CloudFormation change sets and be reviewed before execution. If an infrastructure update fails, CloudFormation rollback behavior is used and the resulting stack events are inspected.
