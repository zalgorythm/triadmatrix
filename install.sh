#!/bin/bash

# TriadMatrix Node Installation Script
# Version: 3.0
# Date: June 19, 2025

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DEFAULT_INSTALL_DIR="$HOME/triadmatrix"
NODE_PORT=8080
NETWORK="mainnet"

# ASCII Art
print_logo() {
    echo -e "${BLUE}"
    echo "   _______   _           _ __  __       _        _       "
    echo "  |__   __| (_)         | |  \\/  |     | |      (_)      "
    echo "     | |_ __ _  __ _  __| | \\  / | __ _| |_ _ __ ___  __ "
    echo "     | | '__| |/ _\` |/ _\` | |\\/| |/ _\` | __| '__| \\ \\/ / "
    echo "     | | |  | | (_| | (_| | |  | | (_| | |_| |  | |>  <  "
    echo "     |_|_|  |_|\\__,_|\\__,_|_|  |_|\\__,_|\\__|_|  |_/_/\\_\\ "
    echo "                                                         "
    echo "                                                         "
    echo -e "${NC}"
    echo -e "${GREEN}◆ TriadMatrix Node Installer ◆${NC}"
    echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo
}

# System check
check_system() {
    echo -e "${BLUE}[System Check]${NC} Verifying requirements..."
    
    # Check Node.js
    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ Node.js not found${NC}"
        echo "Install Node.js: https://nodejs.org/"
        exit 1
    else
        echo -e "${GREEN}✓ Node.js $(node -v)${NC}"
    fi
    
    # Check npm
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}✗ npm not found${NC}"
        exit 1
    else
        echo -e "${GREEN}✓ npm $(npm -v)${NC}"
    fi
    
    # Check Git
    if ! command -v git &> /dev/null; then
        echo -e "${YELLOW}⚠ Git not found (optional)${NC}"
    else
        echo -e "${GREEN}✓ Git $(git --version | cut -d' ' -f3)${NC}"
    fi
}

# User configuration
get_user_input() {
    echo -e "${BLUE}[Configuration]${NC}"
    
    # Installation directory
    read -p "Installation directory [$DEFAULT_INSTALL_DIR]: " user_dir
    INSTALL_DIR="${user_dir:-$DEFAULT_INSTALL_DIR}"
    echo -e "${GREEN}✓ Using: ${INSTALL_DIR}${NC}"
    
    # Port selection
    read -p "Node port [$NODE_PORT]: " user_port
    NODE_PORT="${user_port:-$NODE_PORT}"
    echo -e "${GREEN}✓ Port: ${NODE_PORT}${NC}"
    
    # Network selection
    echo "1) mainnet"
    echo "2) testnet"
    read -p "Network [1]: " network_choice
    case $network_choice in
        2) NETWORK="testnet" ;;
        *) NETWORK="mainnet" ;;
    esac
    echo -e "${GREEN}✓ Network: ${NETWORK}${NC}"
}

# Create project structure
setup_project() {
    echo -e "${BLUE}[Setup]${NC} Creating project..."
    
    # Create directory
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    
    # Initialize Node.js project
    npm init -y > /dev/null
    
    # Install dependencies
    npm install express
    
    # Create server file
    cat > server.js << 'EOF'
const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/', (req, res) => {
  res.send(`
    <!DOCTYPE html>
    <html>
    <head>
      <title>TriadMatrix Node</title>
      <style>
        body { 
          font-family: monospace; 
          background: #0f0f23;
          color: #00cc00;
          text-align: center;
          padding: 50px;
        }
        .logo { font-weight: bold; font-size: 1.2em; }
        .status { color: #00ff00; }
      </style>
    </head>
    <body>
      <div class="logo">
        <pre> 
  _____ _______       _       _____ __  __       _        _       
 |__   __| (_)         | |  \\/  |     | |      (_)      
    | |_ __ _  __ _  __| | \\  / | __ _| |_ _ __ ___  __ 
    | | '__| |/ _\` |/ _\` | |\\/| |/ _\` | __| '__| \\ \\/ / 
    | | |  | | (_| | (_| | |  | | (_| | |_| |  | |>  <  
    |_|_|  |_|\\__,_|\\__,_|_|  |_|\\__,_|\\__|_|  |_/_/\\_\\ 
        </pre>
      </div>
      <h1>TriadMatrix Node Running</h1>
      <p class="status">Status: <strong>Active</strong></p>
      <p>Network: ${process.env.NETWORK}</p>
      <p>Port: ${port}</p>
    </body>
    </html>
  `);
});

app.listen(port, () => {
  console.log(`TriadMatrix node running on port ${port} (${process.env.NETWORK})`);
});
EOF

    echo -e "${GREEN}✓ Project created${NC}"
}

# Create start script
create_start_script() {
    cat > start.sh << EOF
#!/bin/bash
export PORT=$NODE_PORT
export NETWORK=$NETWORK
node server.js
EOF

    chmod +x start.sh
    echo -e "${GREEN}✓ Start script created${NC}"
}

# Create service file (for Linux)
create_service() {
    if [[ "$(uname)" != "Linux" ]]; then
        return
    fi

    read -p "Create system service? [y/N]: " service_resp
    if [[ "$service_resp" != "y" ]]; then
        return
    fi

    SERVICE_FILE="/etc/systemd/system/triadmatrix.service"
    
    sudo bash -c "cat > $SERVICE_FILE" << EOF
[Unit]
Description=TriadMatrix Node Service
After=network.target

[Service]
User=$USER
WorkingDirectory=$INSTALL_DIR
Environment="PORT=$NODE_PORT"
Environment="NETWORK=$NETWORK"
ExecStart=$INSTALL_DIR/start.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable triadmatrix.service
    
    echo -e "${GREEN}✓ System service created${NC}"
    echo -e "Start with: ${YELLOW}sudo systemctl start triadmatrix${NC}"
}

# Final instructions
show_completion() {
    echo -e "\n${GREEN}✓ Installation Complete ✓${NC}"
    echo -e "Directory: ${YELLOW}$INSTALL_DIR${NC}"
    echo -e "Network: ${YELLOW}$NETWORK${NC}"
    echo -e "Port: ${YELLOW}$NODE_PORT${NC}"
    
    echo -e "\n${BLUE}Start manually:${NC}"
    echo -e "1. ${YELLOW}cd $INSTALL_DIR${NC}"
    echo -e "2. ${YELLOW}./start.sh${NC}"
    
    if [[ -f "/etc/systemd/system/triadmatrix.service" ]]; then
        echo -e "\n${BLUE}Service commands:${NC}"
        echo -e "Start: ${YELLOW}sudo systemctl start triadmatrix${NC}"
        echo -e "Status: ${YELLOW}sudo systemctl status triadmatrix${NC}"
        echo -e "Stop: ${YELLOW}sudo systemctl stop triadmatrix${NC}"
    fi
    
    echo -e "\n${GREEN}Node will run at: http://localhost:$NODE_PORT${NC}"
}

# Main flow
main() {
    print_logo
    check_system
    get_user_input
    setup_project
    create_start_script
    create_service
    show_completion
}

main
