# TriadMatrix Node Installer

![TriadMatrix Logo](https://raw.githubusercontent.com/zalgorythm/triadmatr)

## Overview

This installer provides a one-command setup for TriadMatrix nodes. The `install.sh` script handles all system requirements and configuration to deploy a TriadMatrix node from the [official repository](https://github.com/zalgorythm/triadmatrix).

**Important**: This installer pulls the latest version from the official source - do not commit the installed node files to version control.

## Features

- Automatic cloning from official repo
- Dependency verification
- Configuration wizard
- Systemd service setup (Linux)
- Web dashboard configuration
- Auto-update capability

## Installation

### Quick Start
```bash
bash <(curl -s https://raw.githubusercontent.com/zalgorythm/triadmatrix/main/install.sh)
```

### Manual Installation
1. Download the installer:
```bash
wget https://raw.githubusercontent.com/zalgorythm/triadmatrix/main/install.sh
```

2. Make it executable:
```bash
chmod +x install.sh
```

3. Run the installer:
```bash
./install.sh
```

## Usage

### Starting the Node
```bash
cd ~/triadmatrix
./bin/start
```

### Accessing the Dashboard
The web interface will be available at:
```
http://localhost:8080
```

### Managing the Service (Linux)
```bash
# Start
sudo systemctl start triadmatrix

# Stop 
sudo systemctl stop triadmatrix

# Check status
sudo systemctl status triadmatrix
```

## Configuration

The installer supports these options:

| Parameter | Description | Default |
|-----------|-------------|---------|
| `-d PATH` | Installation directory | `~/triadmatrix` |
| `-p PORT` | Web interface port | `8080` |
| `-n NETWORK` | Network environment (`mainnet`/`testnet`) | `mainnet` |
| `-s` | Skip service setup | `false` |

Example:
```bash
./install.sh -d /opt/triad -p 9090 -n testnet
```

## Update Process

To update an existing installation:
```bash
cd ~/triadmatrix
./bin/update
```

## Uninstallation

Complete removal:
```bash
sudo systemctl stop triadmatrix
sudo systemctl disable triadmatrix
sudo rm /etc/systemd/system/triadmatrix.service
rm -rf ~/triadmatrix
```

## Security

### Verification
Always verify the installer's checksum:
```bash
curl -s https://raw.githubusercontent.com/zalgorythm/triadmatrix/main/checksums.txt
sha256sum install.sh
```

### Best Practices
- Run as non-root user
- Configure firewall rules
- Monitor resource usage
- Keep system updated

## Support

For issues with the installer:
1. Check [existing issues](https://github.com/zalgorythm/triadmatrix/issues)
2. Open a new issue if needed

For node configuration questions, see the [official documentation](https://github.com/zalgorythm/triadmatrix/wiki).

## License
Apache 2.0 - See [LICENSE](https://github.com/zalgorythm/triadmatrix/blob/main/LICENSE) in the main repository.

---

This installer deploys the official TriadMatrix node from [zalgorythm/triadmatrix](https://github.com/zalgorythm/triadmatrix). The installed files should remain on the host system and not be committed to version control.
