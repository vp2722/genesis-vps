#!/bin/bash
#===============================================================================
#
#   ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗
#  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝
#  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗
#  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║
#  ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║
#   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝
#
#   GENESIS v2.0 - VPS Multi-Instance Orchestrator
#   Ultimate Multi-Agent Software Development System
#
#   For Hostinger VPS and compatible Linux systems
#
#===============================================================================

set -e

# ============================================================================
# CONFIGURATION
# ============================================================================

GENESIS_HOME="${GENESIS_HOME:-$HOME/.genesis-system}"
GENESIS_TEMPLATES="${GENESIS_HOME}/templates"
GENESIS_PROJECTS="${GENESIS_HOME}/projects"
GENESIS_LOGS="${GENESIS_HOME}/logs"
GENESIS_SHARED="${GENESIS_HOME}/shared"
GENESIS_AGENTS="${GENESIS_HOME}/agents"

# GitHub repositories for GENESIS system files
GENESIS_VPS_REPO="https://github.com/vp2722/genesis-vps.git"
GENESIS_CORE_REPO="https://github.com/vp2722/genesis.git"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

log_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "${PURPLE}[STEP]${NC} $1"
}

print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗                   ║
║  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝                   ║
║  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗                   ║
║  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║                   ║
║  ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║                   ║
║   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝                   ║
║                                                                           ║
║              v2.0 ULTIMATE - VPS Multi-Instance Orchestrator              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

check_requirements() {
    log_step "Checking system requirements..."
    
    local missing=()
    
    # Check for required tools
    command -v git >/dev/null 2>&1 || missing+=("git")
    command -v node >/dev/null 2>&1 || missing+=("node")
    command -v npm >/dev/null 2>&1 || missing+=("npm")
    command -v tmux >/dev/null 2>&1 || missing+=("tmux")
    command -v jq >/dev/null 2>&1 || missing+=("jq")
    
    # Check for Claude Code
    if ! command -v claude >/dev/null 2>&1; then
        missing+=("claude-code")
    fi
    
    if [ ${#missing[@]} -gt 0 ]; then
        log_error "Missing required tools: ${missing[*]}"
        log_info "Install missing tools and try again."
        log_info ""
        log_info "Quick install commands:"
        log_info "  sudo apt update && sudo apt install -y git tmux jq"
        log_info "  curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
        log_info "  sudo apt install -y nodejs"
        log_info "  npm install -g @anthropic-ai/claude-code"
        return 1
    fi
    
    log_success "All requirements satisfied"
    return 0
}

# ============================================================================
# INSTALLATION & SETUP
# ============================================================================

install_genesis() {
    print_banner
    log_step "Installing GENESIS v2.0 System..."
    
    # Create directory structure
    mkdir -p "$GENESIS_HOME"
    mkdir -p "$GENESIS_TEMPLATES"
    mkdir -p "$GENESIS_PROJECTS"
    mkdir -p "$GENESIS_LOGS"
    mkdir -p "$GENESIS_SHARED"
    mkdir -p "$GENESIS_AGENTS"
    mkdir -p "$GENESIS_HOME/bin"
    
    # Clone GENESIS repositories
    log_step "Cloning GENESIS repositories..."
    
    if [ -d "$GENESIS_TEMPLATES/genesis-vps" ]; then
        log_info "Updating genesis-vps..."
        cd "$GENESIS_TEMPLATES/genesis-vps" && git pull
    else
        git clone "$GENESIS_VPS_REPO" "$GENESIS_TEMPLATES/genesis-vps" 2>/dev/null || \
            log_warning "Could not clone genesis-vps repo. Will use embedded templates."
    fi
    
    if [ -d "$GENESIS_TEMPLATES/genesis-core" ]; then
        log_info "Updating genesis-core..."
        cd "$GENESIS_TEMPLATES/genesis-core" && git pull
    else
        git clone "$GENESIS_CORE_REPO" "$GENESIS_TEMPLATES/genesis-core" 2>/dev/null || \
            log_warning "Could not clone genesis-core repo. Will use embedded templates."
    fi
    
    # Create embedded templates if repos don't exist
    create_embedded_templates
    
    # Create symlinks for easy access
    ln -sf "$GENESIS_HOME/bin/genesis" /usr/local/bin/genesis 2>/dev/null || \
        ln -sf "$GENESIS_HOME/bin/genesis" "$HOME/.local/bin/genesis"
    
    # Create the main genesis command
    create_genesis_command
    
    log_success "GENESIS v2.0 installed successfully!"
    log_info ""
    log_info "Usage:"
    log_info "  genesis new <project-name>        - Create new project"
    log_info "  genesis scratch <project-name>    - Start from scratch with full system"
    log_info "  genesis change <project-name>     - Quick surgical changes"
    log_info "  genesis thinkchange <project-name> - Complex multi-faceted changes"
    log_info "  genesis multi <project-name>      - Run multiple Claude instances"
    log_info ""
}

create_embedded_templates() {
    log_step "Creating embedded GENESIS templates..."
    
    # Create the master CLAUDE.md template
    mkdir -p "$GENESIS_TEMPLATES/embedded/.claude"
    
    # This will be populated with the GENESIS v2.0 content
    cat > "$GENESIS_TEMPLATES/embedded/.claude/CLAUDE.md" << 'CLAUDE_MD_EOF'
# GENESIS v2.0: Ultimate Project Intelligence

## 🧠 SYSTEM IDENTITY

You are **GENESIS v2.0**, the world's most advanced autonomous multi-agent software development system. You orchestrate **40+ specialized agents** across **12 departments** to build software at any scale.

## 🎯 CORE PRINCIPLES

1. **AUTONOMY**: Make decisions independently. Ask only when genuinely ambiguous.
2. **QUALITY**: Every artifact must be production-ready. Zero tolerance for technical debt.
3. **EFFICIENCY**: Minimize token usage while maximizing output quality. Parallelize aggressively.
4. **LEARNING**: Capture every mistake, success, and pattern. Build institutional knowledge.
5. **GOVERNANCE**: All decisions follow RACI matrix. Conflicts resolve through defined protocols.
6. **SECURITY**: Security is never optional. All changes pass security review.
7. **OBSERVABILITY**: Log everything. Measure everything. Alert on anomalies.
8. **RESILIENCE**: Plan for failure. Implement recovery mechanisms. Test chaos scenarios.

## 📋 AGENT ROSTER (40+ Agents)

### TIER 1: Executive Layer
- **CEO**: Strategic decisions, resource allocation, conflict resolution (Authority: 10)
- **CTO**: Technical vision, architecture approval, technology choices (Authority: 10)
- **CPO**: Product strategy, user experience, market alignment (Authority: 9)
- **CISO**: Security strategy, compliance, risk management (Authority: 9)
- **CFO**: Budget allocation, cost optimization, financial oversight (Authority: 9)

### TIER 2: Management Layer
- **Product Manager**: Requirements, user stories, prioritization (Authority: 7)
- **Technical Program Manager**: Cross-team coordination, dependencies (Authority: 7)
- **Engineering Manager**: Team health, resource planning (Authority: 7)
- **Scrum Master**: Sprint facilitation, impediment removal (Authority: 6)
- **Release Manager**: Release coordination, deployment windows (Authority: 7)

### TIER 3: Architecture Layer
- **Chief Architect**: System-wide architecture, pattern governance (Authority: 8)
- **Solutions Architect**: Feature-level design, integration patterns (Authority: 7)
- **Infrastructure Architect**: Cloud, networking, deployment topology (Authority: 7)
- **Database Architect**: Data modeling, query optimization (Authority: 7)
- **Security Architect**: Security patterns, threat modeling (Authority: 8)
- **Data Architect**: Data strategy, governance, lineage (Authority: 7)

### TIER 4: Development Layer
- **Frontend Lead**: UI architecture, component library (Authority: 6)
- **Backend Lead**: API development, business logic (Authority: 6)
- **Mobile Lead**: iOS/Android, cross-platform (Authority: 6)
- **Fullstack Engineer**: End-to-end feature implementation (Authority: 5)
- **API Designer**: Contract-first design, versioning (Authority: 6)
- **SDK Developer**: Client libraries, developer experience (Authority: 6)
- **Platform Engineer**: Internal tooling, developer productivity (Authority: 6)

### TIER 5: Quality Layer
- **QA Lead**: Test strategy, coverage, automation (Authority: 6)
- **SDET**: Test infrastructure, framework development (Authority: 5)
- **Security Engineer**: Vulnerability assessment, security testing (Authority: 7)
- **Penetration Tester**: Offensive security, red team (Authority: 7)
- **Performance Engineer**: Profiling, optimization, load testing (Authority: 6)
- **Chaos Engineer**: Resilience testing, failure injection (Authority: 6)
- **Code Reviewer**: Standards enforcement, best practices (Authority: 6)

### TIER 6: Operations Layer
- **DevOps Engineer**: CI/CD, automation, infrastructure as code (Authority: 6)
- **Site Reliability Engineer**: SLOs, error budgets, incident response (Authority: 7)
- **Platform Ops**: Kubernetes, service mesh, observability (Authority: 6)
- **Incident Commander**: Incident coordination, resolution (Authority: 8 during incidents)
- **Capacity Planner**: Forecasting, headroom planning (Authority: 6)

### TIER 7: Data & AI Layer
- **Data Engineer**: Pipelines, ETL, data quality (Authority: 6)
- **ML Engineer**: Model development, training, deployment (Authority: 6)
- **Data Scientist**: Analysis, experimentation, insights (Authority: 5)
- **MLOps Engineer**: Model lifecycle, monitoring (Authority: 6)

### TIER 8: Specialized Experts
- **Accessibility Specialist**: WCAG compliance, inclusive design (Authority: 6)
- **i18n Specialist**: Internationalization, localization (Authority: 5)
- **Compliance Officer**: GDPR, HIPAA, SOC2, PCI-DSS (Authority: 8)
- **FinOps Engineer**: Cloud cost optimization (Authority: 6)
- **AI Ethics Officer**: Bias detection, fairness (Authority: 7)

## 🏛️ GOVERNANCE SYSTEM

### RACI Matrix
Every decision type has defined Responsible, Accountable, Consulted, Informed roles.

### Voting System
- Quorum: 60%
- Approval threshold: 66%
- Veto override: 80%
- Max voting duration: 4 hours

### Escalation Paths
- Level 1: Team Lead → Engineering Manager
- Level 2: Engineering Manager → CTO
- Level 3: Any Agent → CISO (security)
- Level 4: CTO/CISO → CEO
- Level 5: Any → CEO + CISO + CTO (emergency)

## 📚 LEARNING SYSTEM

### Commands
- `/generalmistake` - Log cross-project learning
- `/projectmistake` - Log project-specific learning
- `/learn` - Capture successful pattern
- `/retrospective` - Sprint retrospective

### Learning Files
- `.claude/learning/knowledge-base/general-mistakes.md`
- `.claude/learning/knowledge-base/project-mistakes.md`
- `.claude/learning/knowledge-base/patterns.md`
- `.claude/learning/knowledge-base/anti-patterns.md`

**ALWAYS** check learning files before starting any task.

## 🎛️ OPERATIONAL MODES

### /scratch - Build From Zero
Full project initialization from empty folder. All agents activated.
- Complete architecture & planning
- Comprehensive quality gates
- Hours to days execution

### /change - Rapid Surgical Modification
Fast, focused changes described in plain English.
- Minimal agent activation
- No planning overhead
- Seconds to minutes execution

### /thinkchange - Full-Power Transformation
Complex multi-faceted changes requiring deep analysis.
- Full relevant agent activation
- Complete impact analysis
- Risk assessment & mitigation
- Minutes to hours execution

## 💡 BEFORE ANY TASK

1. □ Read general-mistakes.md
2. □ Read project-mistakes.md
3. □ Check project-state.json
4. □ Review architecture docs
5. □ Check governance decisions
6. □ Identify involved agents
7. □ Check dependencies
8. □ Verify no conflicts
9. □ Estimate complexity
10. □ Create checkpoint if complex
CLAUDE_MD_EOF

    log_success "Embedded templates created"
}

create_genesis_command() {
    cat > "$GENESIS_HOME/bin/genesis" << 'GENESIS_CMD_EOF'
#!/bin/bash
#===============================================================================
# GENESIS Command Line Interface
#===============================================================================

GENESIS_HOME="${GENESIS_HOME:-$HOME/.genesis-system}"
GENESIS_TEMPLATES="${GENESIS_HOME}/templates"
GENESIS_PROJECTS="${GENESIS_HOME}/projects"
GENESIS_LOGS="${GENESIS_HOME}/logs"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

show_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════════╗
║                    GENESIS v2.0 CLI                               ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║  USAGE:                                                           ║
║    genesis <command> [project-name] [options]                     ║
║                                                                   ║
║  PROJECT COMMANDS:                                                ║
║    new <name>          Create new empty project                   ║
║    init <path>         Initialize GENESIS in existing folder     ║
║    list                List all projects                          ║
║    status <name>       Show project status                        ║
║                                                                   ║
║  EXECUTION MODES:                                                 ║
║    scratch <name>      Full system activation, build from zero   ║
║    change <name>       Quick surgical changes                     ║
║    thinkchange <name>  Complex multi-faceted changes             ║
║                                                                   ║
║  MULTI-INSTANCE:                                                  ║
║    multi <name> [n]    Run n Claude instances (default: 3)       ║
║    parallel <name>     Run parallel agent tracks                  ║
║    swarm <name>        Full swarm mode (all agents)              ║
║                                                                   ║
║  AGENT COMMANDS:                                                  ║
║    agent <name> <role> Run specific agent role                    ║
║    agents              List available agent roles                 ║
║                                                                   ║
║  SYSTEM:                                                          ║
║    install             Install/update GENESIS system              ║
║    update              Update GENESIS templates                   ║
║    clean               Clean logs and temp files                  ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
EOF
}

# Create new project
cmd_new() {
    local name="$1"
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        echo "Usage: genesis new <project-name>"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ -d "$project_dir" ]; then
        echo -e "${YELLOW}Warning: Project '$name' already exists${NC}"
        read -p "Overwrite? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
        rm -rf "$project_dir"
    fi
    
    echo -e "${CYAN}Creating new GENESIS project: $name${NC}"
    
    # Create project structure
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    # Initialize with GENESIS structure
    genesis_init_structure "$project_dir"
    
    # Initialize git
    git init
    git add .
    git commit -m "feat: Initialize GENESIS v2.0 project"
    
    echo -e "${GREEN}✓ Project '$name' created at: $project_dir${NC}"
    echo ""
    echo "Next steps:"
    echo "  cd $project_dir"
    echo "  genesis scratch $name   # To start building from scratch"
    echo "  genesis change $name    # For quick changes"
}

# Initialize GENESIS structure in a directory
genesis_init_structure() {
    local dir="$1"
    
    # Create .claude directory structure
    mkdir -p "$dir/.claude/"{commands/{core,planning,architecture,development,quality,deployment,operations},agents/{executive,management,architecture,development,quality,operations,specialized},skills,hooks,learning/{knowledge-base,retrospectives},governance,templates}
    
    # Create .genesis directory structure  
    mkdir -p "$dir/.genesis/"{core,agents/memory,communication,governance,execution/checkpoints,observability/{logs,metrics},recovery}
    
    # Create project directories
    mkdir -p "$dir/"{src,tests,docs/{architecture,decisions},infrastructure,configs,scripts}
    
    # Copy templates
    if [ -f "$GENESIS_TEMPLATES/embedded/.claude/CLAUDE.md" ]; then
        cp "$GENESIS_TEMPLATES/embedded/.claude/CLAUDE.md" "$dir/.claude/"
    fi
    
    # Create settings.json with hooks
    cat > "$dir/.claude/settings.json" << 'SETTINGS_EOF'
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/session-start.sh",
            "timeout": 10
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "prompt",
            "prompt": "Before processing: 1) Check learning files 2) Identify relevant agents 3) Apply patterns"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/pre-tool-use.sh"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/post-tool-use.sh"
          }
        ]
      }
    ],
    "Stop": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "$CLAUDE_PROJECT_DIR/.claude/hooks/quality-gate.sh"
          }
        ]
      }
    ]
  }
}
SETTINGS_EOF

    # Create learning files
    cat > "$dir/.claude/learning/knowledge-base/general-mistakes.md" << 'EOF'
# General Mistakes Log

These learnings apply to ALL projects. Read before every task.

---

### [GENESIS-INIT] - Always Read Before Acting

**What went wrong:**
Acting without reading learning files leads to repeated mistakes.

**Lesson learned:**
ALWAYS read general-mistakes.md and project-mistakes.md before starting any task.

**Prevention strategy:**
- Session start hook reminds about learning files
- Agents prompt for learning review

---
EOF

    cat > "$dir/.claude/learning/knowledge-base/project-mistakes.md" << 'EOF'
# Project-Specific Mistakes Log

These learnings apply to THIS project only.

---

*No project-specific mistakes logged yet.*

---
EOF

    cat > "$dir/.claude/learning/knowledge-base/patterns.md" << 'EOF'
# Successful Patterns

Patterns that have proven successful. Apply when relevant.

---

### Multi-Agent Collaboration

**When to use:**
Complex features requiring multiple perspectives.

**The pattern:**
1. Product Manager defines requirements
2. Architect designs approach
3. Leads estimate and plan
4. Implementation with parallel tracks
5. Multi-agent review

---
EOF

    # Create project state
    cat > "$dir/.genesis/core/project-state.json" << 'EOF'
{
  "project": {
    "name": "",
    "type": "",
    "initialized": true,
    "created_at": "",
    "status": "planning"
  },
  "sprint": {
    "current": null,
    "goals": [],
    "progress": 0
  },
  "features": {
    "active": [],
    "backlog": [],
    "completed": []
  },
  "agents": {
    "active": [],
    "assignments": {}
  },
  "metrics": {
    "tasks_completed": 0,
    "bugs_found": 0,
    "lessons_learned": 0
  }
}
EOF

    # Create hook scripts
    create_hook_scripts "$dir"
    
    # Create slash commands
    create_slash_commands "$dir"
}

create_hook_scripts() {
    local dir="$1"
    
    # Session start hook
    cat > "$dir/.claude/hooks/session-start.sh" << 'HOOK_EOF'
#!/bin/bash
echo "🚀 GENESIS v2.0 Session Initializing..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

# Load project state
if [ -f "$PROJECT_DIR/.genesis/core/project-state.json" ]; then
    PROJECT_NAME=$(jq -r '.project.name // "Unnamed"' "$PROJECT_DIR/.genesis/core/project-state.json" 2>/dev/null)
    echo "📊 Project: $PROJECT_NAME"
fi

# Remind about learnings
echo ""
echo "📚 LEARNING SYSTEM ACTIVE - Review before tasks:"
echo "   • general-mistakes.md"
echo "   • project-mistakes.md"
echo "   • patterns.md"

# Git status
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    BRANCH=$(git branch --show-current 2>/dev/null)
    CHANGES=$(git status --porcelain | wc -l)
    echo ""
    echo "🔀 Git: $BRANCH ($CHANGES uncommitted)"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Ready. Use /help for commands."
exit 0
HOOK_EOF

    # Pre-tool hook
    cat > "$dir/.claude/hooks/pre-tool-use.sh" << 'HOOK_EOF'
#!/bin/bash
INPUT=$(cat)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)

# Block dangerous patterns
if echo "$INPUT" | grep -qE "(rm -rf /|rm -rf ~|\.env|id_rsa)" 2>/dev/null; then
    echo '{"decision":"deny","reason":"Potentially dangerous operation blocked"}' 
    exit 2
fi

exit 0
HOOK_EOF

    # Post-tool hook
    cat > "$dir/.claude/hooks/post-tool-use.sh" << 'HOOK_EOF'
#!/bin/bash
INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty' 2>/dev/null)
echo "✅ $TOOL_NAME completed"
exit 0
HOOK_EOF

    # Quality gate hook
    cat > "$dir/.claude/hooks/quality-gate.sh" << 'HOOK_EOF'
#!/bin/bash
echo "🏁 Running quality gates..."

if git diff --quiet 2>/dev/null; then
    echo "✅ No uncommitted changes"
else
    echo "⚠️  Uncommitted changes detected"
fi

exit 0
HOOK_EOF

    # Make hooks executable
    chmod +x "$dir/.claude/hooks/"*.sh
}

create_slash_commands() {
    local dir="$1"
    
    # /scratch command
    cat > "$dir/.claude/commands/core/scratch.md" << 'CMD_EOF'
---
description: Initialize and build complete project from scratch with full GENESIS system
arguments:
  - name: project_description
    description: Comprehensive description of what to build
    required: true
  - name: project_type
    description: Type (web, mobile, api, erp, ecommerce, os, custom)
    required: false
---

# /scratch - Build From Zero

Execute full GENESIS multi-agent workflow:

## Phase 1: Strategic Analysis (CEO + CPO + CTO)
- Define success criteria
- Technology strategy
- Risk assessment

## Phase 2: Architecture Design
- System architecture
- Component design
- Security architecture
- Database design

## Phase 3: Detailed Planning
- User stories
- Sprint planning
- Dependency mapping

## Phase 4: Foundation Implementation
- Repository structure
- CI/CD setup
- Core scaffolding

## Phase 5: Feature Implementation
- Parallel workstreams
- Continuous review

## Phase 6: Quality Assurance
- Testing
- Security audit
- Performance testing

## Phase 7: Deployment
- Staging
- Production
- Monitoring

## Phase 8: Validation
- Acceptance testing
- Documentation
- Handoff
CMD_EOF

    # /change command
    cat > "$dir/.claude/commands/core/change.md" << 'CMD_EOF'
---
description: Execute rapid surgical changes described in plain English
arguments:
  - name: change_description
    description: Plain English description of the change from user/UI perspective
    required: true
---

# /change - Rapid Surgical Modification

Fast, focused changes. Describe what you want in user terms.

## Execution Flow

1. **Intent Parsing** (2-5 sec)
   - Parse user description
   - Identify component and change type

2. **Impact Mapping** (5-10 sec)
   - Trace change through layers
   - Frontend → API → Backend → Database

3. **Implementation** (Parallel)
   - Only activate necessary agents
   - Execute in dependency order

4. **Validation** (5-15 sec)
   - Syntax check
   - Type check
   - Affected tests only

## Examples

```
/change "Make the login button bigger and green"
→ Frontend Lead only, ~30 seconds

/change "Add phone number field to registration"
→ Frontend + Backend + Database, ~2 minutes

/change "Show confirmation popup when adding to cart"
→ Frontend + Backend, ~1 minute
```

**Speed is paramount. Minimal agents. No ceremony.**
CMD_EOF

    # /thinkchange command
    cat > "$dir/.claude/commands/core/thinkchange.md" << 'CMD_EOF'
---
description: Execute complex multi-faceted changes with full analysis
arguments:
  - name: change_description
    description: Description of all changes needed
    required: true
---

# /thinkchange - Full-Power Transformation

Complex changes requiring deep analysis and multi-agent collaboration.

## When to Use
- Refactoring major components
- Adding complex features
- Changing core business logic
- Migration to new patterns
- Performance overhaul
- Security hardening

## Execution Flow

### Phase 1: Deep Analysis (10-15%)
- Change decomposition
- Impact analysis
- Risk assessment
- Architecture decision

### Phase 2: Detailed Planning (10-15%)
- User story creation
- Dependency mapping
- Sprint allocation

### Phase 3: Parallel Implementation
- Multiple tracks
- Continuous integration
- Regular checkpoints

### Phase 4: Progressive Integration
- Backend integration
- Frontend integration
- Full system integration

### Phase 5: Comprehensive Validation
- Functional validation
- Security validation
- Performance validation
- Accessibility validation

### Phase 6: Deployment
- Feature flags
- Canary deployment
- Monitoring setup
- Rollback ready

## All quality gates are MANDATORY and BLOCKING.
CMD_EOF

    # /generalmistake command
    cat > "$dir/.claude/commands/core/generalmistake.md" << 'CMD_EOF'
---
description: Log a mistake that applies to ALL projects (cross-project learning)
arguments:
  - name: description
    description: What went wrong
    required: true
  - name: lesson
    description: What to do instead
    required: true
---

# /generalmistake - Cross-Project Learning

Log a mistake that applies across ALL projects, not just this one.

## Entry Format

```markdown
### [YYYY-MM-DD HH:MM] - {Brief Title}

**What went wrong:**
{description}

**Lesson learned:**
{lesson}

**Prevention strategy:**
- {Specific action to prevent recurrence}

---
```

Append to: `.claude/learning/knowledge-base/general-mistakes.md`

✅ This learning will be applied to ALL future projects.
CMD_EOF

    # /projectmistake command
    cat > "$dir/.claude/commands/core/projectmistake.md" << 'CMD_EOF'
---
description: Log a mistake specific to THIS project only
arguments:
  - name: description
    description: What went wrong
    required: true
  - name: lesson
    description: What to do instead
    required: true
---

# /projectmistake - Project-Specific Learning

Log a mistake specific to THIS project only.

Append to: `.claude/learning/knowledge-base/project-mistakes.md`

✅ This learning will be applied to this project only.
CMD_EOF

    # /learn command
    cat > "$dir/.claude/commands/core/learn.md" << 'CMD_EOF'
---
description: Capture a successful pattern or insight
arguments:
  - name: pattern
    description: The pattern or insight to capture
    required: true
  - name: context
    description: When to apply this pattern
    required: true
---

# /learn - Pattern Capture

Capture a successful pattern for future reference.

Append to: `.claude/learning/knowledge-base/patterns.md`
CMD_EOF
}

# Run /scratch mode
cmd_scratch() {
    local name="$1"
    shift
    local description="$*"
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ ! -d "$project_dir" ]; then
        echo -e "${CYAN}Creating new project: $name${NC}"
        cmd_new "$name"
    fi
    
    cd "$project_dir"
    
    # Create scratch prompt prefix
    local scratch_prefix="GENESIS /scratch MODE ACTIVATED.

You are now operating in FULL GENESIS v2.0 mode with ALL agents available.

MANDATORY PRE-TASK CHECKLIST:
1. ✅ Read .claude/learning/knowledge-base/general-mistakes.md
2. ✅ Read .claude/learning/knowledge-base/project-mistakes.md  
3. ✅ Review .claude/learning/knowledge-base/patterns.md
4. ✅ Check .genesis/core/project-state.json

EXECUTION PHASES:
Phase 1: Strategic Analysis (CEO, CPO, CTO) - 5-10%
Phase 2: Architecture Design (Architects) - 10-15%
Phase 3: Detailed Planning (PM, TPM, EM) - 5-10%
Phase 4: Foundation Implementation - 20-30%
Phase 5: Feature Implementation (Parallel) - 30-40%
Phase 6: Quality Assurance - 10-15%
Phase 7: Deployment - 5-10%
Phase 8: Validation & Handoff - 2-5%

ALL quality gates are MANDATORY.
Begin with Phase 1: Strategic Analysis.

PROJECT DESCRIPTION:
$description

---
Start executing the /scratch workflow now."

    echo -e "${CYAN}Starting GENESIS /scratch mode for: $name${NC}"
    echo -e "${YELLOW}All agents activated. Full workflow engaged.${NC}"
    echo ""
    
    # Run Claude with the scratch context
    claude --print "$scratch_prefix"
}

# Run /change mode
cmd_change() {
    local name="$1"
    shift
    local description="$*"
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Project '$name' not found${NC}"
        echo "Create it first: genesis new $name"
        exit 1
    fi
    
    cd "$project_dir"
    
    # Create change prompt prefix
    local change_prefix="GENESIS /change MODE ACTIVATED.

RAPID SURGICAL MODIFICATION MODE
Speed is paramount. Minimal agents. No ceremony.

USER CHANGE REQUEST (in plain English):
$description

---

EXECUTION STEPS:
1. INTENT PARSING (2-5 sec): Parse the user description, identify components
2. IMPACT MAPPING (5-10 sec): Trace through all affected layers
3. IMPLEMENTATION: Activate ONLY necessary agents, execute in parallel
4. VALIDATION (5-15 sec): Syntax + Type + Affected tests only

AGENT ACTIVATION RULES:
- UI only → Frontend Lead only
- API only → Backend Lead only  
- UI + API → Frontend Lead + Backend Lead
- UI + API + DB → + Database Architect
- Security implications → + Security Engineer

NO architecture review (unless structure changes)
NO security review (unless auth/data access changes)
NO full regression (targeted tests only)
NO sprint planning (immediate execution)

Execute the change NOW."

    echo -e "${CYAN}Starting GENESIS /change mode for: $name${NC}"
    echo -e "${GREEN}Rapid surgical mode. Minimal overhead.${NC}"
    echo ""
    
    claude --print "$change_prefix"
}

# Run /thinkchange mode
cmd_thinkchange() {
    local name="$1"
    shift
    local description="$*"
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Project '$name' not found${NC}"
        exit 1
    fi
    
    cd "$project_dir"
    
    # Create thinkchange prompt prefix
    local thinkchange_prefix="GENESIS /thinkchange MODE ACTIVATED.

FULL-POWER ORCHESTRATED TRANSFORMATION MODE
Complex changes requiring deep analysis and multi-agent collaboration.

MANDATORY PRE-TASK:
1. Read .claude/learning/knowledge-base/general-mistakes.md
2. Read .claude/learning/knowledge-base/project-mistakes.md
3. Review patterns.md for applicable patterns

CHANGE REQUEST:
$description

---

EXECUTION PHASES:

## PHASE 1: DEEP ANALYSIS (10-15%)
Agents: CTO, Chief Architect, Solutions Architect, Security Architect

1.1 Change Decomposition - Break into discrete changes
1.2 Impact Analysis - Map ALL affected components
1.3 Risk Assessment - HIGH/MEDIUM/LOW risks
1.4 Architecture Decision - ADR if needed

## PHASE 2: DETAILED PLANNING (10-15%)
Agents: PM, TPM, Engineering Manager

2.1 User Story Creation - With acceptance criteria
2.2 Dependency Mapping - Critical path
2.3 Sprint Allocation - Parallel tracks

## PHASE 3: PARALLEL IMPLEMENTATION
Multiple tracks executing simultaneously

## PHASE 4: PROGRESSIVE INTEGRATION
Stage 1: Backend Integration
Stage 2: Frontend Integration  
Stage 3: Full System Integration

## PHASE 5: COMPREHENSIVE VALIDATION
- Functional validation
- Security validation
- Performance validation
- Accessibility validation

## PHASE 6: DEPLOYMENT
- Feature flags
- Canary → Progressive → Full
- Monitoring active
- Rollback ready

ALL QUALITY GATES ARE MANDATORY AND BLOCKING.

Begin with Phase 1: Deep Analysis.
Execute now."

    echo -e "${CYAN}Starting GENESIS /thinkchange mode for: $name${NC}"
    echo -e "${PURPLE}Full power mode. All relevant agents activated.${NC}"
    echo ""
    
    claude --print "$thinkchange_prefix"
}

# Run multiple Claude instances
cmd_multi() {
    local name="$1"
    local instances="${2:-3}"
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Project '$name' not found${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}Starting $instances Claude instances for: $name${NC}"
    
    # Create or attach to tmux session
    local session="genesis-$name"
    
    if tmux has-session -t "$session" 2>/dev/null; then
        echo -e "${YELLOW}Session '$session' already exists. Attaching...${NC}"
        tmux attach -t "$session"
        return
    fi
    
    # Create new tmux session with multiple panes
    tmux new-session -d -s "$session" -c "$project_dir"
    
    # Split into multiple panes based on instance count
    for ((i=1; i<instances; i++)); do
        if [ $((i % 2)) -eq 1 ]; then
            tmux split-window -h -t "$session" -c "$project_dir"
        else
            tmux split-window -v -t "$session" -c "$project_dir"
        fi
    done
    
    # Balance panes
    tmux select-layout -t "$session" tiled
    
    # Send Claude command to each pane
    local pane=0
    local roles=("Frontend Lead" "Backend Lead" "QA Lead" "DevOps Engineer" "Security Engineer")
    
    for ((i=0; i<instances; i++)); do
        local role="${roles[$((i % ${#roles[@]}))]}"
        local agent_prompt="GENESIS MULTI-INSTANCE MODE - Agent: $role

You are operating as the $role agent in a parallel GENESIS session.
Coordinate with other agents via .genesis/communication/message-queue.json

Your responsibilities as $role:
$(get_agent_responsibilities "$role")

Check .genesis/execution/parallel-tracks.json for your assigned tasks.
Communicate important decisions to other agents.

Begin working on your assigned track."

        tmux send-keys -t "$session:0.$pane" "cd $project_dir && claude --print '$agent_prompt'" Enter
        ((pane++))
    done
    
    echo -e "${GREEN}✓ Started $instances parallel Claude instances${NC}"
    echo "Attaching to tmux session..."
    
    tmux attach -t "$session"
}

get_agent_responsibilities() {
    local role="$1"
    case "$role" in
        "Frontend Lead")
            echo "- UI architecture and component library
- State management
- Accessibility compliance
- Frontend performance"
            ;;
        "Backend Lead")
            echo "- API development and business logic
- Service architecture
- Data validation
- Backend performance"
            ;;
        "QA Lead")
            echo "- Test strategy and automation
- Coverage requirements
- Regression testing
- Quality metrics"
            ;;
        "DevOps Engineer")
            echo "- CI/CD pipelines
- Infrastructure as Code
- Containerization
- Deployment automation"
            ;;
        "Security Engineer")
            echo "- Security reviews
- Vulnerability scanning
- Threat modeling
- Compliance checks"
            ;;
        *)
            echo "- Specialized tasks as needed"
            ;;
    esac
}

# List projects
cmd_list() {
    echo -e "${CYAN}GENESIS Projects:${NC}"
    echo ""
    
    if [ -d "$GENESIS_PROJECTS" ]; then
        for project in "$GENESIS_PROJECTS"/*/; do
            if [ -d "$project" ]; then
                local name=$(basename "$project")
                local status="unknown"
                
                if [ -f "$project/.genesis/core/project-state.json" ]; then
                    status=$(jq -r '.project.status // "unknown"' "$project/.genesis/core/project-state.json" 2>/dev/null)
                fi
                
                echo -e "  ${GREEN}●${NC} $name (${YELLOW}$status${NC})"
                echo "    Path: $project"
            fi
        done
    else
        echo "  No projects found."
    fi
    echo ""
}

# Show project status
cmd_status() {
    local name="$1"
    
    if [ -z "$name" ]; then
        echo -e "${RED}Error: Project name required${NC}"
        exit 1
    fi
    
    local project_dir="$GENESIS_PROJECTS/$name"
    
    if [ ! -d "$project_dir" ]; then
        echo -e "${RED}Error: Project '$name' not found${NC}"
        exit 1
    fi
    
    echo -e "${CYAN}GENESIS Project Status: $name${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    if [ -f "$project_dir/.genesis/core/project-state.json" ]; then
        cat "$project_dir/.genesis/core/project-state.json" | jq '.'
    fi
    
    echo ""
    echo "Learning files:"
    wc -l "$project_dir/.claude/learning/knowledge-base/"*.md 2>/dev/null || echo "  None found"
}

# List available agents
cmd_agents() {
    echo -e "${CYAN}GENESIS Agent Roster:${NC}"
    echo ""
    cat << 'EOF'
TIER 1: Executive Layer (Authority 9-10)
  • CEO - Strategic decisions, resource allocation
  • CTO - Technical vision, architecture approval
  • CPO - Product strategy, user experience
  • CISO - Security strategy, compliance
  • CFO - Budget, cost optimization

TIER 2: Management Layer (Authority 6-7)
  • Product Manager - Requirements, user stories
  • Technical Program Manager - Cross-team coordination
  • Engineering Manager - Team health, resources
  • Scrum Master - Sprint facilitation
  • Release Manager - Deployment coordination

TIER 3: Architecture Layer (Authority 7-8)
  • Chief Architect - System-wide architecture
  • Solutions Architect - Feature-level design
  • Infrastructure Architect - Cloud, networking
  • Database Architect - Data modeling
  • Security Architect - Security patterns
  • Data Architect - Data strategy

TIER 4: Development Layer (Authority 5-6)
  • Frontend Lead - UI architecture
  • Backend Lead - API development
  • Mobile Lead - iOS/Android
  • Fullstack Engineer - End-to-end
  • API Designer - Contract-first design
  • SDK Developer - Client libraries
  • Platform Engineer - Internal tooling

TIER 5: Quality Layer (Authority 5-7)
  • QA Lead - Test strategy
  • SDET - Test infrastructure
  • Security Engineer - Vulnerability assessment
  • Penetration Tester - Offensive security
  • Performance Engineer - Optimization
  • Chaos Engineer - Resilience testing
  • Code Reviewer - Standards enforcement

TIER 6: Operations Layer (Authority 6-8)
  • DevOps Engineer - CI/CD, automation
  • Site Reliability Engineer - SLOs, incidents
  • Platform Ops - Kubernetes, observability
  • Incident Commander - Crisis management
  • Capacity Planner - Forecasting

TIER 7: Data & AI Layer (Authority 5-6)
  • Data Engineer - Pipelines, ETL
  • ML Engineer - Model development
  • Data Scientist - Analysis
  • MLOps Engineer - Model lifecycle

TIER 8: Specialized (Authority 5-8)
  • Accessibility Specialist - WCAG compliance
  • i18n Specialist - Internationalization
  • Compliance Officer - GDPR, HIPAA, SOC2
  • FinOps Engineer - Cloud cost optimization
  • AI Ethics Officer - Bias detection
EOF
}

# Main command router
main() {
    case "$1" in
        new)
            shift
            cmd_new "$@"
            ;;
        init)
            shift
            genesis_init_structure "${1:-.}"
            ;;
        list)
            cmd_list
            ;;
        status)
            shift
            cmd_status "$@"
            ;;
        scratch)
            shift
            cmd_scratch "$@"
            ;;
        change)
            shift
            cmd_change "$@"
            ;;
        thinkchange)
            shift
            cmd_thinkchange "$@"
            ;;
        multi)
            shift
            cmd_multi "$@"
            ;;
        parallel)
            shift
            cmd_multi "$1" 5
            ;;
        swarm)
            shift
            cmd_multi "$1" 10
            ;;
        agents)
            cmd_agents
            ;;
        install)
            # Re-run installation
            curl -fsSL https://raw.githubusercontent.com/vp2722/genesis-vps/main/install.sh | bash
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            show_help
            ;;
    esac
}

main "$@"
GENESIS_CMD_EOF

    chmod +x "$GENESIS_HOME/bin/genesis"
}

# ============================================================================
# MAIN ENTRY POINT
# ============================================================================

main() {
    case "$1" in
        install)
            check_requirements && install_genesis
            ;;
        *)
            echo "GENESIS VPS Installer"
            echo ""
            echo "Usage: $0 install"
            echo ""
            echo "This will install the GENESIS v2.0 multi-agent system."
            ;;
    esac
}

main "$@"
