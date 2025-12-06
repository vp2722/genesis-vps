---
name: deployment
description: Manages deployment processes and strategies
trigger_patterns: ["deploy", "release", "rollback", "canary", "blue-green"]
---

# Deployment Skill

## Capability
Execute deployments using various strategies.

## Deployment Strategies
- **Rolling**: Gradual replacement
- **Blue/Green**: Switch between environments
- **Canary**: Gradual traffic shift
- **Feature Flags**: Code-level toggles

## Pre-Deployment Checklist
- [ ] All tests passing
- [ ] Security scan clean
- [ ] Rollback plan ready
- [ ] Monitoring configured
- [ ] Stakeholders notified

## Post-Deployment
- Verify health checks
- Monitor error rates
- Check performance metrics
- Confirm functionality
