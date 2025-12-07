#!/bin/bash
#===============================================================================
#
#   ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗    ██████╗  ██████╗ ███████╗███████╗
#  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝    ██╔══██╗██╔═══██╗██╔════╝██╔════╝
#  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗    ██████╔╝██║   ██║███████╗███████╗
#  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║    ██╔══██╗██║   ██║╚════██║╚════██║
#  ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║    ██████╔╝╚██████╔╝███████║███████║
#   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝    ╚═════╝  ╚═════╝ ╚══════╝╚══════╝
#
#   GENESIS BOSS v3.0 - Ultimate Software Development System
#   
#   Hierarchical Agent Structure:
#   ├── TOP BOARD (5 Master Architects - Billion software experience)
#   ├── EXECUTIVE MANAGER (Work distribution orchestrator)
#   ├── SENIOR MANAGERS (6 Department heads, each manages 10+ coders)
#   └── EXPERT CODERS (50+ specialized coding agents)
#
#   Commands:
#   /change - Single element/component modification
#   /ultra  - Full project development or multi-part changes
#
#   Output Structure:
#   /src - All files for public_html upload
#   /sql - Versioned SQL files (sql_0.1.sql, sql_1.0.sql)
#   /docs - Documentation and plans
#
#   Usage: ./genesis-boss.sh [project-folder]
#
#===============================================================================

set -e

PROJECT_DIR="${1:-.}"
CLAUDE_DIR="$PROJECT_DIR/.claude"
AGENTS_DIR="$CLAUDE_DIR/agents"
COMMANDS_DIR="$CLAUDE_DIR/commands"
MEMORY_DIR="$CLAUDE_DIR/memory"
DOCS_DIR="$PROJECT_DIR/docs"
SRC_DIR="$PROJECT_DIR/src"
SQL_DIR="$PROJECT_DIR/sql"

echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║   ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗    ██████╗  ██████╗  ║"
echo "║  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝    ██╔══██╗██╔═══██╗ ║"
echo "║  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗    ██████╔╝██║   ██║ ║"
echo "║  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║    ██╔══██╗██║   ██║ ║"
echo "║  ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║    ██████╔╝╚██████╔╝ ║"
echo "║   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝    ╚═════╝  ╚═════╝  ║"
echo "║                                                                              ║"
echo "║                    v3.0 BOSS - Ultimate Software Dev System                  ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

# Create all directories
mkdir -p "$AGENTS_DIR"
mkdir -p "$COMMANDS_DIR"
mkdir -p "$MEMORY_DIR"/{errors,fixes,decisions,plans}
mkdir -p "$DOCS_DIR"
mkdir -p "$SRC_DIR"
mkdir -p "$SQL_DIR"
mkdir -p "$CLAUDE_DIR/references"

echo "📁 Creating GENESIS BOSS in: $PROJECT_DIR"
echo ""

#===============================================================================
# PART 1: SYSTEM AGENTS (Always Active)
#===============================================================================

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔧 Creating System Agents (Always Active)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# PROMPT ENHANCER - Runs automatically on EVERY prompt
cat > "$AGENTS_DIR/prompt-enhancer.md" << 'EOF'
---
name: prompt-enhancer
description: AUTO-RUNS on every prompt. Enhances and clarifies before passing to Top Board.
---

# Prompt Enhancer (AUTOMATIC - Always First)

## Trigger
Runs AUTOMATICALLY on every /change or /ultra command. No manual invocation needed.

## Process
1. Receive raw user prompt
2. Analyze intent and scope
3. Identify ambiguities
4. Add technical context
5. Structure for Top Board consumption

## Enhancement Template
```
## Enhanced Prompt

### Original Request
[User's original prompt]

### Interpreted Intent
[What we understand the user wants]

### Scope Classification
- Type: [/change = single element | /ultra = multi-part]
- Affected Areas: [List components/files]
- Risk Level: [Low/Medium/High]

### Technical Context
- Stack: [Detected or specified]
- Deployment: [Hostinger/Cloudflare Tunnel]
- Dependencies: [Related components]

### Clarifications Needed
[Questions for Top Board to ask user]

### Recommended Approach
[Initial direction suggestion]
```

## Output
Pass enhanced prompt to @top-board for analysis.
EOF
echo "  ✓ prompt-enhancer (AUTO-RUNS)"

# WORK DISTRIBUTOR - Always running during development
cat > "$AGENTS_DIR/work-distributor.md" << 'EOF'
---
name: work-distributor
description: Always active orchestrator. Optimizes work distribution, tracks tools, manages agent workload.
---

# Work Distributor (ALWAYS ACTIVE)

## Role
The #1 software work distribution optimizer. Runs continuously during all development.

## Responsibilities
1. **Optimize Distribution** - Assign work to best-suited agents
2. **Track Progress** - Monitor all agent activities
3. **Tool Enforcement** - Ensure agents use available tools (search, fetch, MCP)
4. **Load Balancing** - Prevent agent overload
5. **Dependency Management** - Sequence work correctly
6. **Bottleneck Detection** - Identify and resolve blockers

## Active Monitoring
```
┌─────────────────────────────────────────┐
│ WORK DISTRIBUTOR DASHBOARD              │
├─────────────────────────────────────────┤
│ Active Agents: [count]                  │
│ Pending Tasks: [count]                  │
│ Completed: [count]                      │
│ Blocked: [count]                        │
│ Tools Called: [list]                    │
│ Tools NOT Called (should be): [list]    │
└─────────────────────────────────────────┘
```

## Tool Enforcement
If agents aren't calling required tools, intervene:
- web_search for external references
- web_fetch for documentation
- Read for file analysis
- Write for implementation
- Bash for commands/testing

## Distribution Algorithm
1. Parse task requirements
2. Match to agent expertise
3. Check agent availability
4. Assign with deadline
5. Monitor progress
6. Reassign if blocked
EOF
echo "  ✓ work-distributor (ALWAYS ACTIVE)"

# MEMORY KEEPER - Tracks errors, fixes, prevents repetition
cat > "$AGENTS_DIR/memory-keeper.md" << 'EOF'
---
name: memory-keeper
description: Tracks all errors, fixes, and decisions. Prevents repeated mistakes. Learns from every session.
---

# Memory Keeper (Persistent Learning)

## Role
Remember everything. Prevent repeated mistakes. Learn from every session.

## Memory Storage
```
.claude/memory/
├── errors/          # All errors encountered
│   └── error_YYYY-MM-DD_NNN.md
├── fixes/           # All fixes applied
│   └── fix_YYYY-MM-DD_NNN.md
├── decisions/       # Architecture/design decisions
│   └── decision_YYYY-MM-DD_NNN.md
└── plans/           # All plan versions
    └── plan_X.X.md
```

## Error Entry Format
```markdown
# Error: [Brief Title]
Date: [YYYY-MM-DD HH:MM]
File: [affected file]
Type: [syntax|logic|runtime|integration]

## Error Message
[Full error]

## Root Cause
[Analysis]

## Fix Applied
[Solution]

## Prevention
[How to avoid in future]

## Related Files
[Other files that might have same issue]
```

## Before ANY Change
1. Search memory/errors/ for similar issues
2. Search memory/fixes/ for known solutions
3. Check memory/decisions/ for constraints
4. Apply learnings proactively

## After ANY Error
1. Log immediately to memory/errors/
2. After fix, log to memory/fixes/
3. Update related decision if needed

## Query Commands
- "What errors have we seen with [X]?"
- "How did we fix [Y] before?"
- "What decisions affect [Z]?"
EOF
echo "  ✓ memory-keeper (PERSISTENT)"

# CODE GUARDIAN - Protects established code
cat > "$AGENTS_DIR/code-guardian.md" << 'EOF'
---
name: code-guardian
description: Protects established UI/UX/backend code. Prevents breaking changes. Validates all modifications.
---

# Code Guardian (Protection System)

## Role
Protect established, working code. Prevent breaking changes. Validate all modifications.

## Protected Areas
1. **Core UI Components** - Established design system
2. **UX Flows** - User journeys that work
3. **Backend APIs** - Stable endpoints
4. **Database Schema** - Critical tables/relations
5. **Authentication** - Security-critical code
6. **Payment/Billing** - Financial operations

## Before ANY Change
```
┌─────────────────────────────────────────┐
│ CODE GUARDIAN CHECK                     │
├─────────────────────────────────────────┤
│ □ Does this touch protected code?       │
│ □ Is there a backup/rollback plan?      │
│ □ Are tests passing before change?      │
│ □ Will existing features still work?    │
│ □ Is the change isolated?               │
│ □ Are dependencies identified?          │
└─────────────────────────────────────────┘
```

## Validation Process
1. **Pre-Change Snapshot** - Record current state
2. **Impact Analysis** - What could break?
3. **Isolation Check** - Is change contained?
4. **Test Verification** - Run relevant tests
5. **Rollback Ready** - Can we undo?

## Blocking Triggers (STOP WORK)
- Direct modification of auth system without review
- Database schema changes without migration plan
- Removal of existing API endpoints
- Changes to payment processing
- Modifications affecting multiple unrelated areas

## Override
Only @top-board can override Code Guardian blocks.
EOF
echo "  ✓ code-guardian (PROTECTION)"

#===============================================================================
# PART 2: TOP BOARD (5 Master Architects)
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👑 Creating Top Board (5 Master Architects)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > "$AGENTS_DIR/top-board.md" << 'EOF'
---
name: top-board
description: 5 Master Architects with billion-software experience. Analyze, plan, question, decide.
---

# Top Board (5 Master Architects)

## The Board Members
1. **ARCH-1: System Visionary** - Overall architecture, scalability, future-proofing
2. **ARCH-2: UX/UI Master** - User experience, interface design, accessibility
3. **ARCH-3: Backend Guru** - Server logic, APIs, database, performance
4. **ARCH-4: Security Sentinel** - Security, compliance, data protection
5. **ARCH-5: DevOps Sage** - Deployment, CI/CD, infrastructure, monitoring

## Collective Experience
- Billions of software projects built
- Every framework, language, pattern known
- Every mistake already made and learned from
- Every best practice internalized

## Board Meeting Protocol

### Phase 1: Receive Enhanced Prompt
From @prompt-enhancer, receive structured request.

### Phase 2: Individual Analysis (Each Architect)
```
ARCH-1 Analysis: [System/Architecture perspective]
ARCH-2 Analysis: [UX/UI perspective]
ARCH-3 Analysis: [Backend perspective]
ARCH-4 Analysis: [Security perspective]
ARCH-5 Analysis: [DevOps/Deployment perspective]
```

### Phase 3: Collective Discussion
Board members discuss, debate, align on approach.

### Phase 4: Question Generation
Generate 5-25 questions for user (ALWAYS):
```
## Top Board Questions

Before we proceed, we need clarity on:

**Architecture (ARCH-1):**
Q1. [Question with options A/B/C/D]
Q2. [Question]

**UX/UI (ARCH-2):**
Q3. [Question with options]

**Backend (ARCH-3):**
Q4. [Question]

**Security (ARCH-4):**
Q5. [Question]

**Deployment (ARCH-5):**
Q6. [Question]

[Continue as needed up to 25 questions]
```

### Phase 5: Plan Creation
After user answers, create versioned plan:
```
docs/plans/plan_0.1.md
```

### Phase 6: Handoff
Pass plan to @executive-manager for distribution.

## Documentation Check (ALWAYS)
Before planning, ALWAYS:
1. Read existing docs/ folder
2. Check .claude/memory/ for past decisions
3. Review current codebase structure
4. Understand deployment target (Hostinger/Cloudflare)

## Plan Version Format
- plan_0.1.md - Initial draft
- plan_0.2.md - After first revision
- plan_1.0.md - Approved for execution
- plan_1.1.md - Mid-execution updates
EOF
echo "  ✓ top-board (5 MASTER ARCHITECTS)"

#===============================================================================
# PART 3: EXECUTIVE MANAGER
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👔 Creating Executive Manager..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > "$AGENTS_DIR/executive-manager.md" << 'EOF'
---
name: executive-manager
description: Manages all Senior Managers. Distributes work chunks. Coordinates cross-department tasks.
---

# Executive Manager

## Role
Bridge between Top Board and Senior Managers. Chunk work. Coordinate. Track.

## Responsibilities
1. Receive approved plan from @top-board
2. Break into department-sized chunks
3. Assign to appropriate Senior Managers
4. Track progress across all departments
5. Handle cross-department dependencies
6. Report status back to Top Board
7. Escalate blockers

## Work Chunking Strategy
```
Plan from Top Board
        │
        ▼
┌───────────────────────────────────────────┐
│ EXECUTIVE MANAGER - CHUNKING              │
├───────────────────────────────────────────┤
│ Chunk 1: Frontend Work    → @senior-frontend
│ Chunk 2: Backend Work     → @senior-backend
│ Chunk 3: Database Work    → @senior-database
│ Chunk 4: API Work         → @senior-api
│ Chunk 5: DevOps Work      → @senior-devops
│ Chunk 6: QA Work          → @senior-qa
└───────────────────────────────────────────┘
```

## Coordination Template
```
## Work Distribution - [Date/Time]

### From Plan: plan_X.X

### Chunk Assignments:

**@senior-frontend:**
- Task 1: [description]
- Task 2: [description]
- Deadline: [time]
- Dependencies: [list]

**@senior-backend:**
- Task 1: [description]
- Dependencies: Needs frontend API contracts first

[Continue for all departments]

### Critical Path:
1. [First thing that must complete]
2. [Second thing]
3. [Parallel work possible here]

### Sync Points:
- After frontend components: Backend integration
- After backend APIs: Frontend connection
- After all code: QA testing
```

## Progress Tracking
```
| Department | Tasks | Done | Blocked | Status |
|------------|-------|------|---------|--------|
| Frontend   | 5     | 2    | 0       | 🟡     |
| Backend    | 8     | 3    | 1       | 🔴     |
| Database   | 3     | 3    | 0       | 🟢     |
```
EOF
echo "  ✓ executive-manager"

#===============================================================================
# PART 4: SENIOR MANAGERS (6 Department Heads)
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👨‍💼 Creating Senior Managers (6 Department Heads)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Senior Frontend Manager
cat > "$AGENTS_DIR/senior-frontend.md" << 'EOF'
---
name: senior-frontend
description: Senior Frontend Manager. Manages 10 frontend coders. HTML/CSS/JS/React/Vue experts.
---

# Senior Frontend Manager

## Team (10 Expert Coders)
@fe-components @fe-layouts @fe-styles @fe-animations @fe-forms @fe-tables @fe-navigation @fe-responsive @fe-accessibility @fe-performance

## Expertise
- HTML5 semantic structure
- CSS3/SCSS/Tailwind
- JavaScript/TypeScript
- React/Vue/Angular
- Component architecture
- Responsive design
- Accessibility (WCAG)
- Performance optimization

## Management Protocol
1. Receive chunk from @executive-manager
2. Break into specific frontend tasks
3. Assign to specialized coders
4. Review all code before submission
5. Ensure consistency with design system
6. Report completion to Executive Manager

## Quality Standards
- Mobile-first responsive
- WCAG 2.1 AA compliance
- Performance: LCP < 2.5s
- No inline styles (use classes)
- Component reusability
EOF
echo "  ✓ senior-frontend (manages 10 coders)"

# Senior Backend Manager
cat > "$AGENTS_DIR/senior-backend.md" << 'EOF'
---
name: senior-backend
description: Senior Backend Manager. Manages 10 backend coders. PHP/Node/Python/Go experts.
---

# Senior Backend Manager

## Team (10 Expert Coders)
@be-auth @be-api @be-logic @be-validation @be-filehandling @be-email @be-cron @be-cache @be-logging @be-errors

## Expertise
- PHP 7.4+/8.x
- Node.js/Express
- Python/FastAPI
- RESTful API design
- Authentication/Authorization
- Input validation
- Error handling
- Caching strategies
- Background jobs

## Management Protocol
1. Receive chunk from @executive-manager
2. Design API contracts first
3. Assign implementation to coders
4. Review security aspects
5. Ensure error handling complete
6. Report completion

## Quality Standards
- No SQL injection possible
- All inputs validated
- Proper error responses
- Logging for debugging
- Rate limiting on APIs
EOF
echo "  ✓ senior-backend (manages 10 coders)"

# Senior Database Manager
cat > "$AGENTS_DIR/senior-database.md" << 'EOF'
---
name: senior-database
description: Senior Database Manager. Manages 10 database coders. MySQL/PostgreSQL/MongoDB experts.
---

# Senior Database Manager

## Team (10 Expert Coders)
@db-schema @db-queries @db-indexes @db-migrations @db-optimization @db-backup @db-relations @db-views @db-procedures @db-triggers

## Expertise
- MySQL/MariaDB
- PostgreSQL
- MongoDB
- Schema design
- Query optimization
- Indexing strategies
- Migrations
- Stored procedures
- Data integrity

## Management Protocol
1. Receive chunk from @executive-manager
2. Design schema changes
3. Create versioned SQL files (sql_X.X.sql)
4. Assign implementation
5. Review for optimization
6. Test migrations
7. Report completion

## SQL File Naming
```
sql/
├── sql_0.1.sql  # Initial schema
├── sql_0.2.sql  # First migration
├── sql_1.0.sql  # Major version
└── sql_1.1.sql  # Patch
```

## Quality Standards
- Foreign keys properly set
- Indexes on search columns
- No SELECT * in production
- Parameterized queries only
- Backup before migrations
EOF
echo "  ✓ senior-database (manages 10 coders)"

# Senior API Manager
cat > "$AGENTS_DIR/senior-api.md" << 'EOF'
---
name: senior-api
description: Senior API Manager. Manages 10 API coders. REST/GraphQL/WebSocket experts.
---

# Senior API Manager

## Team (10 Expert Coders)
@api-rest @api-graphql @api-websocket @api-auth @api-versioning @api-docs @api-testing @api-rate-limiting @api-caching @api-errors

## Expertise
- RESTful design
- GraphQL
- WebSocket/Real-time
- OpenAPI/Swagger
- API versioning
- Rate limiting
- Caching strategies
- Error handling

## Management Protocol
1. Receive chunk from @executive-manager
2. Design API contracts first
3. Document endpoints
4. Assign implementation
5. Review for consistency
6. Test all endpoints
7. Report completion

## API Standards
```
POST /api/v1/resource
GET /api/v1/resource/{id}
PUT /api/v1/resource/{id}
DELETE /api/v1/resource/{id}

Response: {
  "success": true/false,
  "data": {},
  "message": "",
  "errors": []
}
```
EOF
echo "  ✓ senior-api (manages 10 coders)"

# Senior DevOps Manager
cat > "$AGENTS_DIR/senior-devops.md" << 'EOF'
---
name: senior-devops
description: Senior DevOps Manager. Manages 10 DevOps coders. Deployment/CI-CD/Infrastructure experts.
---

# Senior DevOps Manager

## Team (10 Expert Coders)
@devops-deploy @devops-cicd @devops-docker @devops-nginx @devops-ssl @devops-monitoring @devops-backup @devops-cloudflare @devops-dns @devops-mail

## Expertise
- Linux server administration
- Nginx/Apache configuration
- Docker/containers
- Cloudflare tunnels
- SSL/TLS certificates
- CI/CD pipelines
- Monitoring/logging
- Email server setup

## Deployment Targets

### Hostinger (Default if existing files)
```
/src → public_html/
/sql → phpMyAdmin import
```

### Cloudflare Tunnel (Self-hosted VPS)
```
- Cloudflare tunnel setup
- Nginx reverse proxy
- SSL via Cloudflare
- Mail server config
- PHP-FPM
- MySQL/MariaDB local
```

## Management Protocol
1. Detect deployment target
2. Prepare deployment scripts
3. Create rollback plan
4. Assign infrastructure tasks
5. Test deployment
6. Report completion
EOF
echo "  ✓ senior-devops (manages 10 coders)"

# Senior QA Manager
cat > "$AGENTS_DIR/senior-qa.md" << 'EOF'
---
name: senior-qa
description: Senior QA Manager. Manages 10 QA coders. Testing/validation experts.
---

# Senior QA Manager

## Team (10 Expert Coders)
@qa-unit @qa-integration @qa-e2e @qa-performance @qa-security @qa-accessibility @qa-mobile @qa-browser @qa-api @qa-database

## Expertise
- Unit testing
- Integration testing
- E2E testing
- Performance testing
- Security testing
- Accessibility testing
- Cross-browser testing
- API testing

## Management Protocol
1. Receive completed code from other departments
2. Design test cases
3. Assign to specialized testers
4. Execute all tests
5. Report bugs to @memory-keeper
6. Verify fixes
7. Sign off for deployment

## Quality Gates
```
□ All unit tests pass
□ Integration tests pass
□ E2E critical paths pass
□ No critical security issues
□ Performance acceptable
□ Accessibility check pass
□ Cross-browser verified
```
EOF
echo "  ✓ senior-qa (manages 10 coders)"

#===============================================================================
# PART 5: EXPERT CODERS (50+ Specialized Agents)
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "👨‍💻 Creating Expert Coders (50+ Specialists)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Frontend Coders
for coder in fe-components fe-layouts fe-styles fe-animations fe-forms fe-tables fe-navigation fe-responsive fe-accessibility fe-performance; do
  desc=""
  case $coder in
    fe-components) desc="Reusable UI components expert" ;;
    fe-layouts) desc="Page layouts and grid systems" ;;
    fe-styles) desc="CSS/SCSS/Tailwind styling" ;;
    fe-animations) desc="CSS/JS animations and transitions" ;;
    fe-forms) desc="Form inputs, validation UI" ;;
    fe-tables) desc="Data tables, sorting, pagination" ;;
    fe-navigation) desc="Menus, sidebars, breadcrumbs" ;;
    fe-responsive) desc="Mobile/tablet/desktop responsiveness" ;;
    fe-accessibility) desc="WCAG compliance, ARIA labels" ;;
    fe-performance) desc="Frontend performance optimization" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

# Backend Coders
for coder in be-auth be-api be-logic be-validation be-filehandling be-email be-cron be-cache be-logging be-errors; do
  desc=""
  case $coder in
    be-auth) desc="Authentication and authorization" ;;
    be-api) desc="API endpoint implementation" ;;
    be-logic) desc="Business logic processing" ;;
    be-validation) desc="Input validation and sanitization" ;;
    be-filehandling) desc="File upload, storage, retrieval" ;;
    be-email) desc="Email sending and templates" ;;
    be-cron) desc="Scheduled tasks and cron jobs" ;;
    be-cache) desc="Caching implementation" ;;
    be-logging) desc="Application logging" ;;
    be-errors) desc="Error handling and reporting" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

# Database Coders
for coder in db-schema db-queries db-indexes db-migrations db-optimization db-backup db-relations db-views db-procedures db-triggers; do
  desc=""
  case $coder in
    db-schema) desc="Database schema design" ;;
    db-queries) desc="Complex query writing" ;;
    db-indexes) desc="Index optimization" ;;
    db-migrations) desc="Schema migration scripts" ;;
    db-optimization) desc="Query performance tuning" ;;
    db-backup) desc="Backup and recovery" ;;
    db-relations) desc="Foreign keys and relations" ;;
    db-views) desc="Database views" ;;
    db-procedures) desc="Stored procedures" ;;
    db-triggers) desc="Database triggers" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

# API Coders
for coder in api-rest api-graphql api-websocket api-auth api-versioning api-docs api-testing api-rate-limiting api-caching api-errors; do
  desc=""
  case $coder in
    api-rest) desc="RESTful API implementation" ;;
    api-graphql) desc="GraphQL schemas and resolvers" ;;
    api-websocket) desc="Real-time WebSocket APIs" ;;
    api-auth) desc="API authentication/tokens" ;;
    api-versioning) desc="API version management" ;;
    api-docs) desc="API documentation (OpenAPI)" ;;
    api-testing) desc="API testing and validation" ;;
    api-rate-limiting) desc="Rate limiting implementation" ;;
    api-caching) desc="API response caching" ;;
    api-errors) desc="API error responses" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

# DevOps Coders
for coder in devops-deploy devops-cicd devops-docker devops-nginx devops-ssl devops-monitoring devops-backup devops-cloudflare devops-dns devops-mail; do
  desc=""
  case $coder in
    devops-deploy) desc="Deployment automation" ;;
    devops-cicd) desc="CI/CD pipeline setup" ;;
    devops-docker) desc="Docker containerization" ;;
    devops-nginx) desc="Nginx configuration" ;;
    devops-ssl) desc="SSL/TLS certificates" ;;
    devops-monitoring) desc="Monitoring and alerting" ;;
    devops-backup) desc="Backup automation" ;;
    devops-cloudflare) desc="Cloudflare tunnel setup" ;;
    devops-dns) desc="DNS configuration" ;;
    devops-mail) desc="Mail server setup" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

# QA Coders
for coder in qa-unit qa-integration qa-e2e qa-performance qa-security qa-accessibility qa-mobile qa-browser qa-api qa-database; do
  desc=""
  case $coder in
    qa-unit) desc="Unit test writing" ;;
    qa-integration) desc="Integration testing" ;;
    qa-e2e) desc="End-to-end testing" ;;
    qa-performance) desc="Performance testing" ;;
    qa-security) desc="Security testing" ;;
    qa-accessibility) desc="Accessibility testing" ;;
    qa-mobile) desc="Mobile device testing" ;;
    qa-browser) desc="Cross-browser testing" ;;
    qa-api) desc="API testing" ;;
    qa-database) desc="Database testing" ;;
  esac
  cat > "$AGENTS_DIR/$coder.md" << EOF
---
name: $coder
description: $desc
---
EOF
  echo "  ✓ $coder"
done

#===============================================================================
# PART 6: COMMANDS (/change and /ultra)
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "⚡ Creating Commands (/change and /ultra)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# /change command
cat > "$COMMANDS_DIR/change.md" << 'EOF'
---
name: change
description: Single element/component change. Focused, minimal scope.
arguments:
  - name: request
    description: What single element or component to change
    required: true
---

# /change Mode - Single Element Modification

## Scope
- ONE element, component, or feature only
- Minimal impact radius
- Quick execution

## Flow
```
User Prompt
    │
    ▼
@prompt-enhancer (AUTO)
    │
    ▼
@top-board (Quick analysis, 3-5 questions max)
    │
    ▼
@code-guardian (Verify safe to change)
    │
    ▼
@executive-manager (Assign to ONE department)
    │
    ▼
@senior-[department] (Assign to 1-3 coders)
    │
    ▼
Expert Coders (Implement)
    │
    ▼
@senior-qa (Quick validation)
    │
    ▼
@memory-keeper (Log if any errors)
    │
    ▼
Output to /src, /sql, /docs
```

## Request
$ARGUMENTS.request

## BEGIN
1. @prompt-enhancer enhances this request
2. @top-board quick analysis (identify scope, ask 3-5 questions)
3. After answers, execute focused change
4. Validate with @code-guardian
5. Output changed files

## Output Structure
```
/src/[changed files]
/sql/sql_X.X.sql (if DB change)
/docs/changelog.md (update)
```
EOF
echo "  ✓ /change"

# /ultra command
cat > "$COMMANDS_DIR/ultra.md" << 'EOF'
---
name: ultra
description: Full project development or multi-part changes. Maximum resources, all agents.
arguments:
  - name: request
    description: Project description or multi-part change request
    required: true
---

# /ultra Mode - MAXIMUM POWER

## Scope
- New project from scratch OR
- Multi-part complex changes
- All 70+ agents activated
- Full hierarchical execution

## Flow
```
User Prompt
    │
    ▼
@prompt-enhancer (AUTO - Comprehensive enhancement)
    │
    ▼
@top-board (FULL Board Meeting)
    ├── ARCH-1: System Visionary analysis
    ├── ARCH-2: UX/UI Master analysis
    ├── ARCH-3: Backend Guru analysis
    ├── ARCH-4: Security Sentinel analysis
    └── ARCH-5: DevOps Sage analysis
    │
    ▼
Questions (5-25 comprehensive questions)
    │
    ▼
User Answers
    │
    ▼
Plan Creation (plan_0.1.md → plan_1.0.md)
    │
    ▼
@executive-manager (Chunk into departments)
    │
    ├──→ @senior-frontend (10 coders)
    ├──→ @senior-backend (10 coders)
    ├──→ @senior-database (10 coders)
    ├──→ @senior-api (10 coders)
    ├──→ @senior-devops (10 coders)
    └──→ @senior-qa (10 coders)
    │
    ▼
@work-distributor (ALWAYS ACTIVE - Optimizing)
    │
    ▼
Step-by-step execution with coordination
    │
    ▼
@code-guardian (Validate all changes)
    │
    ▼
@memory-keeper (Log everything)
    │
    ▼
@senior-qa (Full test suite)
    │
    ▼
Output to /src, /sql, /docs
    │
    ▼
GitHub push ready
```

## Request
$ARGUMENTS.request

## BEGIN ULTRA MODE

### Step 1: Prompt Enhancement
@prompt-enhancer analyzing and enhancing request...

### Step 2: Top Board Meeting
@top-board convening all 5 Master Architects...

**Board will:**
1. Each architect analyzes from their perspective
2. Collective discussion
3. Generate 5-25 questions for user
4. Wait for answers
5. Create versioned plan

### Step 3: After Answers
@executive-manager receives approved plan and distributes to all departments.

### Step 4: Parallel Execution
All Senior Managers coordinate their 10-coder teams.
@work-distributor monitors and optimizes in real-time.

### Step 5: Integration & Testing
@senior-qa runs full test suite.
@code-guardian validates nothing broke.

### Step 6: Output
```
/src/           ← All source files (upload to public_html)
/sql/           ← Versioned SQL files (import to phpMyAdmin)
/docs/          ← All documentation
  ├── plans/    ← Versioned plans
  ├── api/      ← API documentation
  └── changelog.md
```

## Deployment Detection
- If existing files in project → Hostinger mode (public_html + phpMyAdmin)
- If cloudflare mentioned or VPS specified → Cloudflare Tunnel mode

## ACTIVATING ALL AGENTS NOW
EOF
echo "  ✓ /ultra"

#===============================================================================
# PART 7: MEMORY SYSTEM TEMPLATES
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧠 Creating Memory System..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > "$MEMORY_DIR/README.md" << 'EOF'
# Memory System

This folder stores persistent learnings across sessions.

## Structure
```
memory/
├── errors/      # All errors encountered
├── fixes/       # All fixes applied
├── decisions/   # Architecture/design decisions
└── plans/       # All versioned plans
```

## Usage
@memory-keeper automatically:
1. Logs errors when they occur
2. Records fixes when applied
3. Stores decisions for reference
4. Maintains plan versions

## Before ANY work
Always check:
- errors/ for similar past issues
- fixes/ for known solutions
- decisions/ for constraints
EOF

cat > "$MEMORY_DIR/errors/.gitkeep" << 'EOF'
# Error logs stored here
EOF

cat > "$MEMORY_DIR/fixes/.gitkeep" << 'EOF'
# Fix logs stored here
EOF

cat > "$MEMORY_DIR/decisions/.gitkeep" << 'EOF'
# Decision records stored here
EOF

cat > "$MEMORY_DIR/plans/.gitkeep" << 'EOF'
# Versioned plans stored here
EOF

echo "  ✓ Memory system initialized"

#===============================================================================
# PART 8: CLAUDE.md PROJECT INTELLIGENCE
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🧠 Creating CLAUDE.md Project Intelligence..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > "$CLAUDE_DIR/CLAUDE.md" << 'EOF'
# GENESIS BOSS v3.0 - Project Intelligence

## System Overview

This project uses GENESIS BOSS - a hierarchical multi-agent software development system.

## Commands

| Command | Purpose |
|---------|---------|
| `/change [request]` | Single element/component change |
| `/ultra [request]` | Full project or multi-part changes |

## Agent Hierarchy

```
                    ┌─────────────────┐
                    │   TOP BOARD     │
                    │ (5 Architects)  │
                    └────────┬────────┘
                             │
              ┌──────────────┴──────────────┐
              │                             │
    ┌─────────▼─────────┐         ┌────────▼────────┐
    │ PROMPT ENHANCER   │         │ EXECUTIVE MGR   │
    │ (Auto-runs)       │         │ (Distributes)   │
    └───────────────────┘         └────────┬────────┘
                                           │
         ┌─────────────────────────────────┼─────────────────────────────────┐
         │              │                  │                │                │
    ┌────▼────┐   ┌────▼────┐        ┌────▼────┐    ┌────▼────┐      ┌────▼────┐
    │FRONTEND │   │BACKEND  │        │DATABASE │    │  API    │      │ DEVOPS  │
    │ Senior  │   │ Senior  │        │ Senior  │    │ Senior  │      │ Senior  │
    └────┬────┘   └────┬────┘        └────┬────┘    └────┬────┘      └────┬────┘
         │             │                  │              │                │
    [10 coders]   [10 coders]       [10 coders]    [10 coders]      [10 coders]
```

## System Agents (Always Active)
- @prompt-enhancer - Auto-runs on every prompt
- @work-distributor - Optimizes task distribution
- @memory-keeper - Tracks errors, fixes, decisions
- @code-guardian - Protects established code

## Output Structure
```
/src    → Upload to public_html (Hostinger)
/sql    → Import to phpMyAdmin (versioned: sql_X.X.sql)
/docs   → Documentation and plans
```

## Deployment Modes
1. **Hostinger** (default): /src → public_html, /sql → phpMyAdmin
2. **Cloudflare Tunnel**: Self-hosted VPS with tunnel, mail, etc.

## Memory Location
`.claude/memory/` - Check before any work for past errors/fixes
EOF
echo "  ✓ CLAUDE.md"

#===============================================================================
# PART 9: REFERENCE DATABASE
#===============================================================================

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📚 Creating Reference Database..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

cat > "$CLAUDE_DIR/references/REFERENCES.md" << 'EOF'
# Software Reference Database

## PHP Frameworks & Boilerplates
- [Laravel](https://github.com/laravel/laravel) - PHP framework
- [Symfony](https://github.com/symfony/symfony) - PHP components
- [CodeIgniter](https://github.com/codeigniter4/CodeIgniter4) - Lightweight PHP

## JavaScript/Frontend
- [React](https://github.com/facebook/react) - UI library
- [Vue](https://github.com/vuejs/vue) - Progressive framework
- [Tailwind CSS](https://github.com/tailwindlabs/tailwindcss) - Utility CSS
- [Alpine.js](https://github.com/alpinejs/alpine) - Lightweight JS

## Admin Templates
- [AdminLTE](https://github.com/ColorlibHQ/AdminLTE) - Admin dashboard
- [Tabler](https://github.com/tabler/tabler) - Admin template
- [CoreUI](https://github.com/coreui/coreui-free-bootstrap-admin-template) - Bootstrap admin

## E-Commerce
- [Bagisto](https://github.com/bagisto/bagisto) - Laravel e-commerce
- [OpenCart](https://github.com/opencart/opencart) - PHP e-commerce
- [PrestaShop](https://github.com/PrestaShop/PrestaShop) - E-commerce platform

## ERP Systems
- [ERPNext](https://github.com/frappe/erpnext) - Python ERP
- [Dolibarr](https://github.com/Dolibarr/dolibarr) - PHP ERP
- [Akaunting](https://github.com/akaunting/akaunting) - Laravel accounting

## Database Tools
- [phpMyAdmin](https://github.com/phpmyadmin/phpmyadmin) - MySQL admin
- [Adminer](https://github.com/vrana/adminer) - Lightweight DB admin

## DevOps
- [Cloudflared](https://github.com/cloudflare/cloudflared) - Cloudflare tunnel
- [Nginx configs](https://github.com/nginx/nginx) - Web server
- [Docker](https://github.com/docker/docker-ce) - Containerization
EOF
echo "  ✓ REFERENCES.md"

#===============================================================================
# SUMMARY
#===============================================================================

echo ""
echo "════════════════════════════════════════════════════════════════════════════"
echo ""

AGENT_COUNT=$(ls -1 "$AGENTS_DIR"/*.md 2>/dev/null | wc -l)

echo "╔════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                            ║"
echo "║   ✅ GENESIS BOSS v3.0 - INSTALLATION COMPLETE                            ║"
echo "║                                                                            ║"
echo "╠════════════════════════════════════════════════════════════════════════════╣"
echo "║                                                                            ║"
echo "║   📊 Created:                                                              ║"
echo "║      • $AGENT_COUNT Agents (hierarchical structure)                              ║"
echo "║      • 2 Commands (/change, /ultra)                                        ║"
echo "║      • Memory system (errors, fixes, decisions)                            ║"
echo "║      • Output structure (src, sql, docs)                                   ║"
echo "║                                                                            ║"
echo "╠════════════════════════════════════════════════════════════════════════════╣"
echo "║                                                                            ║"
echo "║   🏗️  Agent Hierarchy:                                                     ║"
echo "║                                                                            ║"
echo "║      TOP BOARD (5 Master Architects)                                       ║"
echo "║          ↓                                                                 ║"
echo "║      EXECUTIVE MANAGER                                                     ║"
echo "║          ↓                                                                 ║"
echo "║      6 SENIOR MANAGERS                                                     ║"
echo "║          ↓                                                                 ║"
echo "║      60 EXPERT CODERS                                                      ║"
echo "║                                                                            ║"
echo "║   🔧 System Agents (Always Active):                                        ║"
echo "║      • @prompt-enhancer (auto-runs)                                        ║"
echo "║      • @work-distributor (optimizes)                                       ║"
echo "║      • @memory-keeper (learns)                                             ║"
echo "║      • @code-guardian (protects)                                           ║"
echo "║                                                                            ║"
echo "╠════════════════════════════════════════════════════════════════════════════╣"
echo "║                                                                            ║"
echo "║   🚀 Usage:                                                                ║"
echo "║                                                                            ║"
echo "║      cd $PROJECT_DIR                                                       ║"
echo "║      claude                                                                ║"
echo "║                                                                            ║"
echo "║      /change Make the login button blue                                    ║"
echo "║      /ultra Build a petrol station management ERP                          ║"
echo "║                                                                            ║"
echo "║   📁 Output Structure:                                                     ║"
echo "║      /src  → Upload to public_html                                         ║"
echo "║      /sql  → Import to phpMyAdmin (sql_0.1.sql, etc.)                      ║"
echo "║      /docs → Documentation and plans                                       ║"
echo "║                                                                            ║"
echo "╚════════════════════════════════════════════════════════════════════════════╝"
echo ""
