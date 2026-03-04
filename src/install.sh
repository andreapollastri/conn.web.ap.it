#!/bin/bash

# Installation script for conn
# Makes the 'conn' command available globally on the system

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Installing SSH Connection Manager ===${NC}"
echo ""

# Resolve script directory (works when run from repo root as ./src/install.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONN_PATH="$SCRIPT_DIR/conn"

# Check if conn script exists
if [ ! -f "$CONN_PATH" ]; then
    echo -e "${RED}Error: 'conn' not found at $CONN_PATH${NC}"
    exit 1
fi

# Make the script executable
echo -e "${YELLOW}Making script executable...${NC}"
chmod +x "$CONN_PATH"

# Copy the script to /usr/local/bin
echo -e "${YELLOW}Copying script to /usr/local/bin/ ...${NC}"
if sudo cp "$CONN_PATH" /usr/local/bin/conn; then
    echo -e "${GREEN}✓ Script copied successfully!${NC}"
else
    echo -e "${RED}Error copying the script.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Installation completed successfully! ===${NC}"
echo ""
echo -e "You can now use the ${GREEN}conn${NC} command from any directory!"
echo ""
echo "Usage examples:"
echo "  conn list          - Show all servers"
echo "  conn add           - Add a new server"
echo "  conn to <alias>    - Connect to a server"
echo "  conn help          - Show complete help"
echo ""

