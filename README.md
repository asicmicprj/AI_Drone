# AI_Drone Project

This repository contains the AI_Drone project setup, including DonkeyCar framework configuration and automation scripts for Raspberry Pi 4 with Debian.

## Overview

This project provides a complete setup for running DonkeyCar (a Python self-driving library) on Raspberry Pi 4 with the latest Debian OS. It includes automated installation scripts, comprehensive documentation, and GitHub Actions workflows for code quality checks.

## Project Structure

```
projects/
├── donkeycar/              # DonkeyCar framework source code
│   ├── donkeycar/         # Main DonkeyCar package
│   ├── INSTALLATION.md    # Detailed installation guide
│   ├── QUICK_START.md     # Quick start guide
│   ├── REQUIREMENTS.txt   # System dependencies list
│   └── README.md          # DonkeyCar documentation
├── .github/
│   └── workflows/
│       └── pylint.yml     # GitHub Actions workflow for code linting
├── install_python_and_donkeycar.sh  # Automated installation script
├── pi-display/            # Raspberry Pi display utilities
└── README.md              # This file
```

## Features

- **Automated Installation**: Single-command setup script for Python 3.11.9 and DonkeyCar
- **Full Dependency Management**: Automatic installation of all required system libraries
- **Virtual Environment**: Isolated Python environment for DonkeyCar
- **Code Quality**: GitHub Actions workflow for automated pylint checks
- **Comprehensive Documentation**: Installation guides, quick start, and requirements

## Requirements

- **Hardware**: Raspberry Pi 4 (recommended: 4GB RAM minimum)
- **OS**: Debian (latest version)
- **Python**: 3.11.9 (automatically installed via pyenv)
- **Storage**: ~7GB free space (5GB for Python, 2GB for DonkeyCar dependencies)
- **Network**: Internet connection for downloading dependencies

## Quick Start

### Automated Installation (Recommended)

1. Clone the repository:
```bash
git clone git@github.com:asicmicprj/AI_Drone.git
cd AI_Drone
```

2. Run the installation script:
```bash
./install_python_and_donkeycar.sh
```

The script will automatically:
- Install all system dependencies
- Install pyenv if not present
- Compile and install Python 3.11.9 with all required modules
- Create virtual environment `env` in `projects/` directory
- Install DonkeyCar with all Raspberry Pi dependencies
- Verify all components are working

**Installation time**: ~30-70 minutes (depending on internet speed and Raspberry Pi performance)

### Manual Installation

For manual installation instructions, see [donkeycar/INSTALLATION.md](donkeycar/INSTALLATION.md).

## Usage

### Activate Virtual Environment

```bash
cd ~/projects
source env/bin/activate
```

### Create a DonkeyCar Project

```bash
donkey createcar --path ~/mycar
```

### Run Your Car

```bash
cd ~/mycar
python manage.py drive
```

### Deactivate Environment

```bash
deactivate
```

## Key Components

### DonkeyCar

DonkeyCar is a minimalist and modular self-driving library for Python. This project includes:

- Support for Raspberry Pi 4 hardware
- TensorFlow 2.15 for deep learning
- Camera integration (Picamera2)
- Motor control (PCA9685)
- Web interface for remote control
- Data collection and training tools

For more information, see [donkeycar/README.md](donkeycar/README.md).

### Installation Script

`install_python_and_donkeycar.sh` - Comprehensive installation script that:

- Checks and installs system dependencies
- Manages Python installation via pyenv
- Creates isolated virtual environment
- Installs DonkeyCar with all required packages
- Verifies installation and module functionality

### GitHub Actions

Automated code quality checks via pylint:
- Runs on push/PR for Python files in `donkeycar/`
- Uses Python 3.11
- Checks code style and potential issues
- Configured with project-specific settings

## Documentation

- **[donkeycar/INSTALLATION.md](donkeycar/INSTALLATION.md)**: Detailed installation guide
- **[donkeycar/QUICK_START.md](donkeycar/QUICK_START.md)**: Quick start guide
- **[donkeycar/REQUIREMENTS.txt](donkeycar/REQUIREMENTS.txt)**: System dependencies list
- **[donkeycar/README.md](donkeycar/README.md)**: DonkeyCar framework documentation

## System Dependencies

The following system libraries are automatically installed by the installation script:

- `libffi-dev` - Critical for ctypes module
- `libssl-dev` - SSL/TLS support
- `libbz2-dev`, `libreadline-dev`, `libsqlite3-dev` - Python modules support
- `libncurses-dev`, `liblzma-dev`, `tk-dev` - Additional module support
- `libcap-dev` - Required for picamera2
- `build-essential` - Compilation tools
- `python3-dev`, `python3-pil`, `python3-smbus` - Python development headers

## Troubleshooting

### Python modules not working

If Python was compiled without required modules, reinstall it:
```bash
pyenv uninstall -f 3.11.9
./install_python_and_donkeycar.sh
```

### Installation fails

Make sure all system dependencies are installed before running the script:
```bash
sudo apt-get update
sudo apt-get install -y libffi-dev build-essential libssl-dev libbz2-dev \
  libreadline-dev libsqlite3-dev libncurses-dev liblzma-dev tk-dev \
  xz-utils zlib1g-dev libcap-dev python3-dev python3-pil python3-smbus
```

### Virtual environment not found

The virtual environment is created at `~/projects/env`. Activate it with:
```bash
source ~/projects/env/bin/activate
```

## Contributing

When contributing code:

1. Follow Python style guidelines (PEP 8)
2. Ensure code passes pylint checks (max line length: 120)
3. Test on Raspberry Pi 4 with Debian
4. Update documentation if needed

The GitHub Actions workflow will automatically check your code quality on push/PR.

## License

This project uses the DonkeyCar framework, which is licensed under the MIT License.

## Links

- **DonkeyCar Official**: https://www.donkeycar.com
- **DonkeyCar Documentation**: https://docs.donkeycar.com
- **DonkeyCar Discord**: https://discord.gg/PN6kFeA
- **Repository**: https://github.com/asicmicprj/AI_Drone

## Support

For issues related to:
- **DonkeyCar framework**: Check [DonkeyCar documentation](https://docs.donkeycar.com) or [Discord community](https://discord.gg/PN6kFeA)
- **Installation problems**: See [INSTALLATION.md](donkeycar/INSTALLATION.md)
- **Project-specific issues**: Open an issue in this repository

## Version Information

- **Python**: 3.11.9
- **DonkeyCar**: 5.2.dev5
- **TensorFlow**: 2.15.1
- **OS**: Debian (latest)
- **Hardware**: Raspberry Pi 4

---

**Note**: This project is optimized for Raspberry Pi 4 with Debian. For other platforms, refer to the official DonkeyCar documentation.

