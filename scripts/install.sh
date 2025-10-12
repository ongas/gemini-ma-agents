#!/bin/bash
# Install gemini-ma agent definitions to a project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$(dirname "$SCRIPT_DIR")/agents"

# Usage message
usage() {
    echo "Usage: $0 <project_path> [agent_name...]"
    echo ""
    echo "Install agent definitions to a project's .gemini/agents/ directory"
    echo ""
    echo "Arguments:"
    echo "  project_path    Path to the target project"
    echo "  agent_name      (Optional) Specific agent(s) to install"
    echo "                  If omitted, all agents will be installed"
    echo ""
    echo "Examples:"
    echo "  $0 /path/to/project              # Install all agents"
    echo "  $0 /path/to/project local-coder  # Install only local-coder"
    echo "  $0 ~/myproject local-coder python-expert  # Install multiple agents"
    exit 1
}

# Check arguments
if [ $# -lt 1 ]; then
    usage
fi

PROJECT_PATH="$1"
shift

# Validate project path
if [ ! -d "$PROJECT_PATH" ]; then
    echo -e "${RED}Error: Project path does not exist: $PROJECT_PATH${NC}"
    exit 1
fi

# Create .gemini/agents directory if it doesn't exist
DEST_DIR="$PROJECT_PATH/.gemini/agents"
if [ ! -d "$DEST_DIR" ]; then
    echo -e "${YELLOW}Creating $DEST_DIR${NC}"
    mkdir -p "$DEST_DIR"
fi

# Determine which agents to install
if [ $# -eq 0 ]; then
    # Install all agents
    AGENTS=($(ls "$AGENTS_DIR"/*.md 2>/dev/null | xargs -n 1 basename))
    if [ ${#AGENTS[@]} -eq 0 ]; then
        echo -e "${RED}Error: No agent definitions found in $AGENTS_DIR${NC}"
        exit 1
    fi
    echo -e "${GREEN}Installing all agents...${NC}"
else
    # Install specific agents
    AGENTS=()
    for agent in "$@"; do
        # Add .md extension if not present
        if [[ ! "$agent" =~ \.md$ ]]; then
            agent="${agent}.md"
        fi
        AGENTS+=("$agent")
    done
fi

# Install agents
INSTALLED=0
SKIPPED=0
FAILED=0

for agent in "${AGENTS[@]}"; do
    SOURCE="$AGENTS_DIR/$agent"
    DEST="$DEST_DIR/$agent"

    if [ ! -f "$SOURCE" ]; then
        echo -e "${RED}✗ Agent not found: $agent${NC}"
        ((FAILED++))
        continue
    fi

    if [ -f "$DEST" ]; then
        echo -e "${YELLOW}! $agent already exists, overwriting...${NC}"
    fi

    cp "$SOURCE" "$DEST"
    echo -e "${GREEN}✓ Installed: $agent${NC}"
    ((INSTALLED++))
done

# Summary
echo ""
echo "Installation complete!"
echo "  Installed: $INSTALLED"
if [ $SKIPPED -gt 0 ]; then
    echo "  Skipped:   $SKIPPED"
fi
if [ $FAILED -gt 0 ]; then
    echo "  Failed:    $FAILED"
fi

echo ""
echo "Verify with:"
echo "  cd $PROJECT_PATH"
echo "  gemini-ma --list-agents"
