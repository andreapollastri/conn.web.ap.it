#!/bin/bash

# Remote installer for conn — downloads and installs without cloning the repo
# Usage: curl -fsSL https://conn.web.ap.it/go.sh | bash

REPO_URL="https://raw.githubusercontent.com/andreapollastri/conn.web.ap.it/main"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Installing conn (SSH Connection Manager) ===${NC}"
echo ""

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

echo -e "${YELLOW}Downloading conn...${NC}"
if command -v curl &> /dev/null; then
    curl -fsSL "$REPO_URL/conn" -o "$TMP_DIR/conn"
elif command -v wget &> /dev/null; then
    wget -q "$REPO_URL/conn" -O "$TMP_DIR/conn"
else
    echo -e "${RED}Error: curl or wget is required.${NC}"
    exit 1
fi

if [ ! -s "$TMP_DIR/conn" ]; then
    echo -e "${RED}Error: failed to download conn.${NC}"
    exit 1
fi

chmod +x "$TMP_DIR/conn"
echo -e "${YELLOW}Installing to /usr/local/bin/ ...${NC}"

if sudo cp "$TMP_DIR/conn" /usr/local/bin/conn; then
    echo -e "${GREEN}✓ conn installed successfully!${NC}"
else
    echo -e "${RED}Error: failed to install.${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== Installation completed! ===${NC}"
echo ""
echo -e "Use ${GREEN}conn${NC} from any directory:"
echo "  conn list          - Show all servers"
echo "  conn add           - Add a new server"
echo "  conn to <alias>    - Connect to a server"
echo "  conn help          - Show complete help"
echo ""
