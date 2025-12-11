#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "🚀 Installing OpenCode Commands, Agents, and Plugins..."

# Check if OpenCode config directory exists
if [ ! -d "$HOME/.config/opencode" ]; then
    echo -e "${YELLOW}⚠️  OpenCode config directory not found. Creating it...${NC}"
    mkdir -p "$HOME/.config/opencode/command"
    mkdir -p "$HOME/.config/opencode/agent"
    mkdir -p "$HOME/.config/opencode/plugin"
fi

# Check if command directory exists
if [ ! -d "$HOME/.config/opencode/command" ]; then
    echo -e "${YELLOW}Creating command directory...${NC}"
    mkdir -p "$HOME/.config/opencode/command"
fi

# Check if agent directory exists
if [ ! -d "$HOME/.config/opencode/agent" ]; then
    echo -e "${YELLOW}Creating agent directory...${NC}"
    mkdir -p "$HOME/.config/opencode/agent"
fi

# Check if plugin directory exists
if [ ! -d "$HOME/.config/opencode/plugin" ]; then
    echo -e "${YELLOW}Creating plugin directory...${NC}"
    mkdir -p "$HOME/.config/opencode/plugin"
fi

# Check if tool directory exists
if [ ! -d "$HOME/.config/opencode/tool" ]; then
    echo -e "${YELLOW}Creating tool directory...${NC}"
    mkdir -p "$HOME/.config/opencode/tool"
fi

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if commands directory exists
if [ ! -d "$SCRIPT_DIR/commands" ]; then
    echo -e "${RED}❌ Error: commands directory not found!${NC}"
    exit 1
fi

# Count commands to install
COMMAND_COUNT=$(ls -1 "$SCRIPT_DIR/commands"/*.md 2>/dev/null | wc -l)

if [ "$COMMAND_COUNT" -eq 0 ]; then
    echo -e "${RED}❌ Error: No command files found in commands directory!${NC}"
    exit 1
fi

echo -e "${GREEN}Found $COMMAND_COUNT commands to install${NC}"

# Create command symlinks
echo "Installing commands..."
for cmd_file in "$SCRIPT_DIR/commands"/*.md; do
    cmd_name=$(basename "$cmd_file")
    target="$HOME/.config/opencode/command/$cmd_name"
    
    # Remove existing symlink or file if it exists
    if [ -e "$target" ] || [ -L "$target" ]; then
        echo -e "${YELLOW}  Replacing existing: $cmd_name${NC}"
        rm "$target"
    fi
    
    # Create symlink
    ln -s "$cmd_file" "$target"
    echo -e "${GREEN}  ✓ Installed command: $cmd_name${NC}"
done

# Create agent symlinks (if agents directory exists)
if [ -d "$SCRIPT_DIR/agents" ]; then
    AGENT_COUNT=$(ls -1 "$SCRIPT_DIR/agents"/*.md 2>/dev/null | wc -l)
    
    if [ "$AGENT_COUNT" -gt 0 ]; then
        echo ""
        echo "Installing agents..."
        for agent_file in "$SCRIPT_DIR/agents"/*.md; do
            agent_name=$(basename "$agent_file")
            target="$HOME/.config/opencode/agent/$agent_name"
            
            # Remove existing symlink or file if it exists
            if [ -e "$target" ] || [ -L "$target" ]; then
                echo -e "${YELLOW}  Replacing existing: $agent_name${NC}"
                rm "$target"
            fi
            
            # Create symlink
            ln -s "$agent_file" "$target"
            echo -e "${GREEN}  ✓ Installed agent: $agent_name${NC}"
        done
    fi
fi

# Create plugin symlinks (if plugins directory exists)
if [ -d "$SCRIPT_DIR/plugins" ]; then
    PLUGIN_COUNT=$(find "$SCRIPT_DIR/plugins" -type f \( -name "*.js" -o -name "*.ts" \) 2>/dev/null | wc -l)
    
    if [ "$PLUGIN_COUNT" -gt 0 ]; then
        echo ""
        echo "Installing plugins..."
        for plugin_file in "$SCRIPT_DIR/plugins"/*.js "$SCRIPT_DIR/plugins"/*.ts; do
            # Skip if glob didn't match any files
            [ -e "$plugin_file" ] || continue
            
            plugin_name=$(basename "$plugin_file")
            target="$HOME/.config/opencode/plugin/$plugin_name"
            
            # Remove existing symlink or file if it exists
            if [ -e "$target" ] || [ -L "$target" ]; then
                echo -e "${YELLOW}  Replacing existing: $plugin_name${NC}"
                rm "$target"
            fi
            
            # Create symlink
            ln -s "$plugin_file" "$target"
            echo -e "${GREEN}  ✓ Installed plugin: $plugin_name${NC}"
        done
    fi
fi

# Create tool symlinks (if tools directory exists)
if [ -d "$SCRIPT_DIR/tools" ]; then
    TOOL_COUNT=$(find "$SCRIPT_DIR/tools" -type f \( -name "*.js" -o -name "*.ts" -o -name "*.mjs" \) 2>/dev/null | wc -l)
    
    if [ "$TOOL_COUNT" -gt 0 ]; then
        echo ""
        echo "Installing tools..."
        for tool_file in "$SCRIPT_DIR/tools"/*.js "$SCRIPT_DIR/tools"/*.ts "$SCRIPT_DIR/tools"/*.mjs; do
            # Skip if glob didn't match any files
            [ -e "$tool_file" ] || continue
            
            tool_name=$(basename "$tool_file")
            target="$HOME/.config/opencode/tool/$tool_name"
            
            # Remove existing symlink or file if it exists
            if [ -e "$target" ] || [ -L "$target" ]; then
                echo -e "${YELLOW}  Replacing existing: $tool_name${NC}"
                rm "$target"
            fi
            
            # Create symlink
            ln -s "$tool_file" "$target"
            echo -e "${GREEN}  ✓ Installed tool: $tool_name${NC}"
        done
    fi
fi

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo ""
echo "Commands installed:"
ls -1 "$HOME/.config/opencode/command" | grep -E "\.md$" | sed 's/\.md$//' | sed 's/^/  \//g'

if [ -d "$HOME/.config/opencode/agent" ] && [ "$(ls -A $HOME/.config/opencode/agent/*.md 2>/dev/null)" ]; then
    echo ""
    echo "Agents installed:"
    ls -1 "$HOME/.config/opencode/agent" | grep -E "\.md$" | sed 's/\.md$//' | sed 's/^/  @/g'
fi

if [ -d "$HOME/.config/opencode/plugin" ] && [ "$(find $HOME/.config/opencode/plugin -type f \( -name "*.js" -o -name "*.ts" \) 2>/dev/null)" ]; then
    echo ""
    echo "Plugins installed:"
    ls -1 "$HOME/.config/opencode/plugin" | grep -E "\.(js|ts)$" | sed 's/\.\(js\|ts\)$//' | sed 's/^/  - /g'
fi

if [ -d "$HOME/.config/opencode/tool" ] && [ "$(find $HOME/.config/opencode/tool -type f \( -name "*.js" -o -name "*.ts" -o -name "*.mjs" \) 2>/dev/null)" ]; then
    echo ""
    echo "Tools installed:"
    ls -1 "$HOME/.config/opencode/tool" | grep -E "\.(js|ts|mjs)$" | sed 's/\.\(js\|ts\|mjs\)$//' | sed 's/^/  - /g'
fi

echo ""
echo "Usage:"
echo "  Commands: Type / in OpenCode TUI to see all available commands"
echo "  Agents: Press Tab to cycle through agents, or use @agent-name to invoke"
echo "  Plugins: Automatically loaded by OpenCode on startup"
echo "  Tools: Available to the agent automatically"
echo ""
echo "To update: cd $SCRIPT_DIR && git pull && ./install.sh"
