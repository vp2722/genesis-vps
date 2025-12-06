# Standard Deployment Runbook

## Pre-Deployment Checklist
- [ ] All tests passing on CI
- [ ] Security scan clean
- [ ] Code review approved
- [ ] Rollback plan documented
- [ ] Stakeholders notified

## Deployment Steps
1. Create release branch
2. Run final tests
3. Deploy to staging
4. Verify staging
5. Deploy to production
6. Verify production
7. Monitor for issues

## Rollback Procedure
1. Identify issue
2. Execute rollback command
3. Verify rollback success
4. Notify stakeholders
5. Document incident

## Contacts
- On-call SRE: [contact]
- Release Manager: [contact]
