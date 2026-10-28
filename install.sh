#!/usr/bin/env bash
set -e

# ==============================================================================
# AndroidSentinel Universal Installer
# One-line installer for Cursor, Claude Code, VS Code, Windsurf, Codex, and Antigravity
# ==============================================================================

REPO="kurians2006/androidsentinel"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${GREEN}${BOLD}"
echo "     _              _           _     _ ____             _   _            _ "
echo "    / \\   _ __   __| |_ __ ___ (_) __| / ___|  ___ _ __ | |_(_)_ __   ___| |"
echo "   / _ \\ | '_ \\ / _\` | '__/ _ \\| |/ _\` \\___ \\ / _ \\ '_ \\| __| | '_ \\ / _ \\ |"
echo "  / ___ \\| | | | (_| | | | (_) | | (_| |___) |  __/ | | | |_| | | | |  __/ |"
echo " /_/   \\_\\_| |_|\\__,_|_|  \\___/|_|\\__,_|____/ \\___|_| |_|\\__|_|_| |_|\\___|_|"
echo -e "${NC}"
echo -e "${BOLD}🛡️  AndroidSentinel Universal Agent Installer for Android & Kotlin${NC}\n"

TARGET_DIR="${PWD}"
echo -e "Installing into current workspace: ${YELLOW}${TARGET_DIR}${NC}\n"

fetch_file() {
    local remote_path="$1"
    local local_path="$2"
    local dir
    dir=$(dirname "$local_path")
    mkdir -p "$dir"
    
    if curl -sSL -f "${BASE_URL}/${remote_path}" -o "$local_path" 2>/dev/null; then
        echo -e "  ${GREEN}✓${NC} Installed: ${local_path}"
    else
        echo -e "  ${YELLOW}⚠${NC} Skipped: ${remote_path}"
    fi
}

echo -e "${BOLD}1. Installing Universal Agent Manifests (Claude Code, Codex, Windsurf):${NC}"
fetch_file "CLAUDE.md" "${TARGET_DIR}/CLAUDE.md"
fetch_file "AGENTS.md" "${TARGET_DIR}/AGENTS.md"
fetch_file ".windsurfrules" "${TARGET_DIR}/.windsurfrules"

echo -e "\n${BOLD}2. Installing Cursor Rules (.cursorrules & modern .mdc):${NC}"
fetch_file "examples/.cursorrules" "${TARGET_DIR}/.cursorrules"
fetch_file ".cursor/rules/kotlin-coroutines.mdc" "${TARGET_DIR}/.cursor/rules/kotlin-coroutines.mdc"
fetch_file ".cursor/rules/compose-performance.mdc" "${TARGET_DIR}/.cursor/rules/compose-performance.mdc"
fetch_file ".cursor/rules/android-security.mdc" "${TARGET_DIR}/.cursor/rules/android-security.mdc"
fetch_file ".cursor/rules/android-architectures-solid.mdc" "${TARGET_DIR}/.cursor/rules/android-architectures-solid.mdc"

echo -e "\n${BOLD}3. Installing GitHub Copilot & VS Code Instructions:${NC}"
fetch_file ".github/copilot-instructions.md" "${TARGET_DIR}/.github/copilot-instructions.md"

echo -e "\n${BOLD}4. Installing Antigravity & Agent Skills:${NC}"
fetch_file "packages/skills/android-code-review/SKILL.md" "${TARGET_DIR}/.gemini/skills/android-code-review/SKILL.md"
fetch_file "packages/skills/android-security-audit/SKILL.md" "${TARGET_DIR}/.gemini/skills/android-security-audit/SKILL.md"
fetch_file "packages/skills/compose-architect/SKILL.md" "${TARGET_DIR}/.gemini/skills/compose-architect/SKILL.md"
fetch_file "packages/skills/external-pr-reviewer/SKILL.md" "${TARGET_DIR}/.gemini/skills/external-pr-reviewer/SKILL.md"

echo -e "\n${BOLD}5. Installing Standalone AndroidSentinel CLI:${NC}"
fetch_file "bin/androidsentinel" "${TARGET_DIR}/bin/androidsentinel"
chmod +x "${TARGET_DIR}/bin/androidsentinel" 2>/dev/null || true

echo -e "\n${GREEN}${BOLD}🎉 AndroidSentinel successfully installed!${NC}"
echo -e "Your workspace is now armed with Kotlin Coroutines, Jetpack Compose, OWASP MASVS, MVVM, MVI, and Clean Architecture rules."
echo -e "Ready to use in ${BOLD}Cursor, Claude Code, VS Code, Codex, Windsurf, and Antigravity${NC}.\n"
