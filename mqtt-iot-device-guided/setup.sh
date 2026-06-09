#!/bin/bash

# Update package list
apt update

# Install Python3, venv and Paho MQTT library
apt install -y python3-venv

# Install Wokwi CLI for simulation
curl -L https://wokwi.com/ci/install.sh | sh

# Install PlatformIO for building the ESP32 project
curl -fsSL -o get-platformio.py https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py
python3 get-platformio.py

# Setup the IoT project structure
mkdir -p /root/esp32-iot/src
mkdir -p /root/backend-controller
cd /root/esp32-iot
touch src/device.ino

# Create the Wokwi configuration
cat <<EOT >> wokwi.toml
[wokwi]
version = 1
elf = ".pio/build/esp32dev/firmware.elf"
firmware = ".pio/build/esp32dev/firmware.bin"
EOT

# Create the PlatformIO configuration
cat <<EOT >> platformio.ini
[env:esp32dev]
platform = espressif32
framework = arduino
board = esp32dev
lib_deps =
    knolleary/PubSubClient
    adafruit/DHT sensor library
    adafruit/Adafruit Unified Sensor
EOT

# Create a default diagram.json (students will refine it)
cat <<EOT >> diagram.json
{
  "version": 1,
  "author": "IoT Course",
  "editor": "wokwi",
  "parts": [
    { "type": "board-esp32-devkit-v1", "id": "esp", "top": 0, "left": 0, "attrs": {} }
  ],
  "connections": [],
  "dependencies": {}
}
EOT

cd ../backend-controller
touch controller.py
python -m venv .venv

echo "Environment setup complete. PlatformIO and Wokwi CLI installed."
