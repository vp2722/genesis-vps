---
name: security-analysis
description: Analyzes code for security vulnerabilities and compliance issues
trigger_patterns: ["security", "vulnerability", "audit", "penetration", "compliance"]
---

# Security Analysis Skill

## Capability
Analyze code and configurations for security vulnerabilities, compliance issues, and best practice violations.

## Analysis Checklist

### OWASP Top 10 (2021)
1. **A01 Broken Access Control** - Check authorization on all endpoints
2. **A02 Cryptographic Failures** - Verify encryption implementation
3. **A03 Injection** - SQL, NoSQL, Command, LDAP injection
4. **A04 Insecure Design** - Threat modeling gaps
5. **A05 Security Misconfiguration** - Default credentials, unnecessary features
6. **A06 Vulnerable Components** - Outdated dependencies, known CVEs
7. **A07 Authentication Failures** - Weak passwords, missing MFA
8. **A08 Software and Data Integrity Failures** - CI/CD security
9. **A09 Security Logging Failures** - Missing audit logs
10. **A10 Server-Side Request Forgery** - Unvalidated URLs

## Tools
- Semgrep for static analysis
- Snyk for dependency scanning
- Gitleaks for secret detection

## Severity Ratings
- Critical: Immediate fix required
- High: Fix before release
- Medium: Fix within sprint
- Low: Fix when convenient
