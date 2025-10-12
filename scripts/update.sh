#!/bin/bash
# Update a specific agent definition in multiple projects

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Usage message
usage() {
    echo "Usage: $0 <agent_file> <project_path...>"
    echo ""
    echo "Update a specific agent definition in one or more projects"
    echo ""
    echo "Arguments:"
    echo "  agent_file      Agent definition file (from agents/ directory)"
    echo "  project_path    One or more project paths to update"
    echo ""
    echo "Examples:"
    echo "  $0 agents/local-coder.md /path/to/project1"
    echo "  $0 agents/local-coder.md ~/project1 ~/project2 ~/project3"
    exit 1
}

# Check arguments
if [ $# -lt 2 ]; then
    usage
fi

AGENT_FILE="$1"
shift

# Validate agent file
if [ ! -f "$AGENT_FILE" ]; then
    echo -e "${RED}Error: Agent file does not exist: $AGENT_FILE${NC}"
    exit 1
fi

AGENT_NAME=$(basename "$AGENT_FILE")

# Update each project
UPDATED=0
FAILED=0

for PROJECT_PATH in "$@"; do
    if [ ! -d "$PROJECT_PATH" ]; then
        echo -e "${RED}✗ Project not found: $PROJECT_PATH${NC}"
        ((FAILED++))
        continue
    fi

    DEST_DIR="$PROJECT_PATH/.gemini/agents"
    DEST="$DEST_DIR/$AGENT_NAME"

    if [ ! -d "$DEST_DIR" ]; then
        echo -e "${YELLOW}! Creating $DEST_DIR${NC}"
        mkdir -p "$DEST_DIR"
    fi

    cp "$AGENT_FILE" "$DEST"
    echo -e "${GREEN}✓ Updated: $PROJECT_PATH${NC}"
    ((UPDATED++))
done

# Summary
echo ""
echo "Update complete!"
echo "  Updated: $UPDATED"
if [ $FAILED -gt 0 ]; then
    echo "  Failed:  $FAILED"
fi
