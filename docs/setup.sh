#!/bin/bash

# Remote installer for conn — downloads and installs without cloning the repo
# Usage: curl -fsSL https://conn.web.ap.it/setup.sh | bash

REPO_OWNER="andreapollastri"
REPO_NAME="conn.web.ap.it"
REPO_FILE="src/conn"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}=== Installing conn (SSH Connection Manager) ===${NC}"
echo ""

TMP_DIR=$(mktemp -d)
trap "rm -rf $TMP_DIR" EXIT

# Prefer commit-SHA URL — raw.githubusercontent.com/.../main/... is often CDN-stale.
sha=""
if command -v curl >/dev/null 2>&1; then
    sha=$(curl -fsSL --connect-timeout 5 --max-time 15 \
        "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/main" 2>/dev/null \
        | grep -o '"sha"[[:space:]]*:[[:space:]]*"[0-9a-f]\{40\}"' \
        | head -1 \
        | grep -o '[0-9a-f]\{40\}')
elif command -v wget >/dev/null 2>&1; then
    sha=$(wget -q -T 15 -O - \
        "https://api.github.com/repos/${REPO_OWNER}/${REPO_NAME}/commits/main" 2>/dev/null \
        | grep -o '"sha"[[:space:]]*:[[:space:]]*"[0-9a-f]\{40\}"' \
        | head -1 \
        | grep -o '[0-9a-f]\{40\}')
fi

if [ -n "$sha" ]; then
    DOWNLOAD_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${sha}/${REPO_FILE}"
else
    DOWNLOAD_URL="https://cdn.jsdelivr.net/gh/${REPO_OWNER}/${REPO_NAME}@main/${REPO_FILE}"
fi

echo -e "${YELLOW}Downloading conn...${NC}"
if command -v curl >/dev/null 2>&1; then
    curl -fsSL -H 'Cache-Control: no-cache' "$DOWNLOAD_URL" -o "$TMP_DIR/conn"
elif command -v wget >/dev/null 2>&1; then
    wget -q --no-cache -O "$TMP_DIR/conn" "$DOWNLOAD_URL"
else
    echo -e "${RED}Error: curl or wget is required.${NC}"
    exit 1
fi

if [ ! -s "$TMP_DIR/conn" ]; then
    echo -e "${RED}Error: failed to download conn.${NC}"
    exit 1
fi

if ! bash -n "$TMP_DIR/conn" 2>/dev/null; then
    echo -e "${RED}Error: downloaded file failed syntax check.${NC}"
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
