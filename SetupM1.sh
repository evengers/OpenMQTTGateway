#!/bin/bash

# OpenMQTTGateway PlatformIO Setup for Mac M1

# Ensures Python 3.11 from Homebrew is used for reliable builds

set -e  # Exit on any error

echo “==========================================”
echo “Mac M1 PlatformIO Setup Script”
echo “For OpenMQTTGateway with PicoMQTT Broker”
echo “==========================================”
echo “”

# ===== STEP 1: Verify Python 3.11 from Homebrew =====

echo “Step 1: Verifying Python 3.11 installation…”

# Check if Python 3.11 is installed via Homebrew

if ! command -v /opt/homebrew/bin/python3.11 &> /dev/null; then
echo “❌ Python 3.11 not found in Homebrew.”
echo “Installing Python 3.11 via Homebrew…”
brew install python@3.11
else
echo “✅ Python 3.11 found: $(which python3.11)”
fi

# Verify it’s ARM64

ARCH=$(/opt/homebrew/bin/python3.11 -c “import platform; print(platform.machine())”)
echo “Python architecture: $ARCH”
if [ “$ARCH” != “arm64” ]; then
echo “⚠️  Warning: Python is not running natively on ARM64!”
fi

# Create alias for this session

alias python3=’/opt/homebrew/bin/python3.11’
alias pip3=’/opt/homebrew/bin/pip3.11’

echo “”

# ===== STEP 2: Clean PlatformIO Environment =====

echo “Step 2: Cleaning PlatformIO cache and packages…”

# Remove PlatformIO cache directories

if [ -d ~/.platformio ]; then
echo “Removing ~/.platformio/packages…”
rm -rf ~/.platformio/packages

```
echo "Removing ~/.platformio/platforms..."
rm -rf ~/.platformio/platforms

echo "Removing ~/.platformio/.cache..."
rm -rf ~/.platformio/.cache

echo "✅ PlatformIO cache cleaned"
```

else
echo “No existing PlatformIO installation found”
fi

# Remove project-specific cache if we’re in a project directory

if [ -d .pio ]; then
echo “Removing .pio project cache…”
rm -rf .pio
echo “✅ Project cache cleaned”
fi

echo “”

# ===== STEP 3: Install/Update PlatformIO =====

echo “Step 3: Installing/Updating PlatformIO with Python 3.11…”

# Uninstall existing PlatformIO to ensure clean install

/opt/homebrew/bin/pip3.11 uninstall -y platformio 2>/dev/null || true

# Install PlatformIO using Python 3.11

/opt/homebrew/bin/pip3.11 install –upgrade platformio

# Verify installation

PIO_VERSION=$(/opt/homebrew/bin/pio –version)
echo “✅ PlatformIO installed: $PIO_VERSION”

echo “”

# ===== STEP 4: Force Library Installation =====

echo “Step 4: Pre-installing libraries for esp32-ble-broker environment…”

# Check if we’re in an OpenMQTTGateway project directory

if [ ! -f “platformio.ini” ]; then
echo “⚠️  Warning: platformio.ini not found in current directory”
echo “Please run this script from your OpenMQTTGateway project root”
echo “”
echo “Setup complete! Next steps:”
echo “1. cd /path/to/OpenMQTTGateway”
echo “2. Run: /opt/homebrew/bin/pio pkg install -e esp32-ble-broker”
echo “3. Run: /opt/homebrew/bin/pio run -e esp32-ble-broker”
else
echo “Found platformio.ini, installing packages…”
/opt/homebrew/bin/pio pkg install -e esp32-ble-broker

```
echo ""
echo "Verifying installed libraries..."
/opt/homebrew/bin/pio pkg list -e esp32-ble-broker

echo ""
echo "✅ All libraries installed successfully!"
```

fi

echo “”
echo “==========================================”
echo “Setup Complete!”
echo “==========================================”
echo “”
echo “To build your project, run:”
echo “  /opt/homebrew/bin/pio run -t clean -e esp32-ble-broker”
echo “  /opt/homebrew/bin/pio run -e esp32-ble-broker -v”
echo “”
echo “To upload to ESP32:”
echo “  1. Find your port: ls /dev/cu.*”
echo “  2. Upload: /opt/homebrew/bin/pio run -e esp32-ble-broker -t upload –upload-port /dev/cu.usbserial-XXXX”
echo “”
echo “To monitor serial output:”
echo “  /opt/homebrew/bin/pio device monitor –port /dev/cu.usbserial-XXXX –baud 115200”
echo “”
echo “TIP: Add this to your ~/.zshrc for easier commands:”
echo “  export PATH="/opt/homebrew/bin:$PATH"”
echo “  alias pio=’/opt/homebrew/bin/pio’”
echo “”
