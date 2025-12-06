# GENESIS v2.0 - VPS Multi-Agent Orchestrator

```
   ██████╗ ███████╗███╗   ██╗███████╗███████╗██╗███████╗
  ██╔════╝ ██╔════╝████╗  ██║██╔════╝██╔════╝██║██╔════╝
  ██║  ███╗█████╗  ██╔██╗ ██║█████╗  ███████╗██║███████╗
  ██║   ██║██╔══╝  ██║╚██╗██║██╔══╝  ╚════██║██║╚════██║
  ╚██████╔╝███████╗██║ ╚████║███████╗███████║██║███████║
   ╚═════╝ ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝╚══════╝
```

> **The Ultimate Multi-Agent Software Development System for Claude Code**

GENESIS v2.0 orchestrates **40+ specialized AI agents** to build any software - from simple apps to enterprise platforms - with zero human code.

---

## 🚀 Quick Install

```bash
# Clone this repo
git clone https://github.com/vp2722/genesis-vps.git
cd genesis-vps

# Run installer
chmod +x genesis-local-install.sh
./genesis-local-install.sh

# Reload shell and authenticate Claude
source ~/.bashrc
claude auth
```

---

## 📋 The 3 Operational Modes

### 🏗️ `/scratch` - Build From Zero

Full project initialization from empty folder. Activates ALL 40+ agents.

```bash
genesis scratch my-app "Build a real-time chat application with React, Node.js, and WebSockets"
```

**Use when:** New projects, complete rewrites, new major products  
**Duration:** Hours to days

---

### ⚡ `/change` - Rapid Surgical Modification

Fast, focused changes described in plain English. Minimal agents, maximum speed.

```bash
genesis change my-app "Make the send button green and larger"
genesis change my-app "Add a phone number field to registration"
```

**Use when:** UI changes, adding fields, fixing bugs, updating text  
**Duration:** Seconds to minutes

---

### 🧠 `/thinkchange` - Full-Power Transformation

Complex changes requiring deep analysis and multi-agent collaboration.

```bash
genesis thinkchange my-app "Add end-to-end encryption for all messages"
```

**Use when:** Major refactoring, complex features, architecture changes  
**Duration:** Minutes to hours

---

## 🎯 Command Reference

| Command | Description |
|---------|-------------|
| `genesis new <name>` | Create new project |
| `genesis scratch <name> "desc"` | Build from zero (full power) |
| `genesis change <name> "desc"` | Quick surgical changes |
| `genesis thinkchange <name> "desc"` | Complex multi-faceted changes |
| `genesis multi <name> [n]` | Run n Claude instances in parallel |
| `genesis list` | List all projects |
| `genesis status <name>` | Show project status |
| `genesis agents` | List all 40+ agents |

---

## 👥 Agent Tiers

| Tier | Agents | Authority |
|------|--------|-----------|
| Executive | CEO, CTO, CPO, CISO, CFO | 9-10 |
| Management | PM, TPM, EM, Scrum Master, Release Manager | 6-7 |
| Architecture | Chief, Solutions, Infra, DB, Security Architect | 7-8 |
| Development | Frontend, Backend, Mobile, API, SDK, Platform | 5-6 |
| Quality | QA, SDET, Security, Performance, Chaos Engineer | 5-7 |
| Operations | DevOps, SRE, Platform Ops, Incident Commander | 6-8 |
| Data & AI | Data Engineer, ML Engineer, MLOps, Analytics | 5-6 |
| Specialized | Accessibility, i18n, Compliance, FinOps, AI Ethics | 5-8 |

---

## 📁 Project Structure

```
my-project/
├── .claude/
│   ├── CLAUDE.md              # Master project intelligence
│   ├── settings.json          # Hooks configuration
│   ├── commands/core/         # Slash commands
│   ├── hooks/                 # Automation hooks
│   └── learning/knowledge-base/
│       ├── general-mistakes.md
│       ├── project-mistakes.md
│       └── patterns.md
├── .genesis/
│   └── core/project-state.json
├── src/
├── tests/
└── docs/
```

---

## 🔧 Requirements

- Linux (Ubuntu 20.04+ / Debian 11+)
- Node.js 20.x+
- git, tmux, jq, curl
- Claude Code CLI

---

## 📚 Learning Commands (Inside Claude)

```bash
/generalmistake "What happened" "Lesson"   # Cross-project learning
/projectmistake "What happened" "Lesson"   # Project-specific
/learn "Pattern" "When to use"             # Capture success
```

---

## 🛠️ Troubleshooting

**"genesis: command not found"**
```bash
source ~/.bashrc
```

**"claude: command not found"**
```bash
npm install -g @anthropic-ai/claude-code
claude auth
```

---

## 📄 License

MIT License

---

<p align="center">
  <b>Built for building anything.</b><br>
  GENESIS v2.0 - Zero Human Code Development
</p>
