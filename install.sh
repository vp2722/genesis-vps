#!/bin/bash
#===============================================================================
# GENESIS v2.0 Quick Installer
# Run with: curl -fsSL https://raw.githubusercontent.com/vp2722/genesis-vps/main/install.sh | bash
#===============================================================================

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

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
║              v2.0 ULTIMATE - Quick Installer                              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${CYAN}[STEP 1/5]${NC} Checking requirements..."

# Check for required tools
missing=()
command -v git >/dev/null 2>&1 || missing+=("git")
command -v node >/dev/null 2>&1 || missing+=("node")
command -v npm >/dev/null 2>&1 || missing+=("npm")
command -v tmux >/dev/null 2>&1 || missing+=("tmux")
command -v jq >/dev/null 2>&1 || missing+=("jq")

if [ ${#missing[@]} -gt 0 ]; then
    echo -e "${YELLOW}Missing: ${missing[*]}${NC}"
    echo -e "${CYAN}Installing dependencies...${NC}"
    
    if command -v apt >/dev/null 2>&1; then
        sudo apt update
        sudo apt install -y git tmux jq curl
        
        if ! command -v node >/dev/null 2>&1; then
            curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
            sudo apt install -y nodejs
        fi
    else
        echo -e "${RED}Please install manually: ${missing[*]}${NC}"
        exit 1
    fi
fi

echo -e "${GREEN}✓ All requirements satisfied${NC}"

echo -e "${CYAN}[STEP 2/5]${NC} Installing Claude Code..."

if ! command -v claude >/dev/null 2>&1; then
    npm install -g @anthropic-ai/claude-code
    echo -e "${YELLOW}Please run 'claude auth' to authenticate after installation${NC}"
else
    echo -e "${GREEN}✓ Claude Code already installed${NC}"
fi

echo -e "${CYAN}[STEP 3/5]${NC} Creating GENESIS directory structure..."

GENESIS_HOME="$HOME/.genesis-system"
mkdir -p "$GENESIS_HOME"/{templates,projects,logs,shared,agents,bin}

echo -e "${CYAN}[STEP 4/5]${NC} Downloading GENESIS system files..."

# Clone repositories
if [ -d "$GENESIS_HOME/templates/genesis-vps" ]; then
    cd "$GENESIS_HOME/templates/genesis-vps" && git pull 2>/dev/null || true
else
    git clone https://github.com/vp2722/genesis-vps.git "$GENESIS_HOME/templates/genesis-vps" 2>/dev/null || true
fi

if [ -d "$GENESIS_HOME/templates/genesis-core" ]; then
    cd "$GENESIS_HOME/templates/genesis-core" && git pull 2>/dev/null || true
else
    git clone https://github.com/vp2722/genesis.git "$GENESIS_HOME/templates/genesis-core" 2>/dev/null || true
fi

echo -e "${CYAN}[STEP 5/5]${NC} Installing GENESIS CLI..."

# Download the full installer and run it
curl -fsSL https://raw.githubusercontent.com/vp2722/genesis-vps/main/genesis-vps-installer.sh -o /tmp/genesis-installer.sh
chmod +x /tmp/genesis-installer.sh
/tmp/genesis-installer.sh install

# Add to PATH
if ! grep -q "genesis-system/bin" "$HOME/.bashrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.genesis-system/bin:$PATH"' >> "$HOME/.bashrc"
fi

if ! grep -q "genesis-system/bin" "$HOME/.zshrc" 2>/dev/null; then
    echo 'export PATH="$HOME/.genesis-system/bin:$PATH"' >> "$HOME/.zshrc" 2>/dev/null || true
fi

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║           GENESIS v2.0 INSTALLED SUCCESSFULLY!                    ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "Next steps:"
echo -e "  ${CYAN}1.${NC} Reload your shell:  ${YELLOW}source ~/.bashrc${NC}"
echo -e "  ${CYAN}2.${NC} Authenticate Claude: ${YELLOW}claude auth${NC}"
echo -e "  ${CYAN}3.${NC} Create a project:    ${YELLOW}genesis new my-app${NC}"
echo -e "  ${CYAN}4.${NC} Start building:      ${YELLOW}genesis scratch my-app \"Build a...\"${NC}"
echo ""
echo -e "Commands:"
echo -e "  ${GREEN}genesis new${NC} <n>          - Create new project"
echo -e "  ${GREEN}genesis scratch${NC} <n>      - Build from zero (full power)"
echo -e "  ${GREEN}genesis change${NC} <n>       - Quick surgical changes"
echo -e "  ${GREEN}genesis thinkchange${NC} <n>  - Complex multi-faceted changes"
echo -e "  ${GREEN}genesis multi${NC} <n> [n]    - Run multiple Claude instances"
echo -e "  ${GREEN}genesis --help${NC}              - Show all commands"
echo ""
