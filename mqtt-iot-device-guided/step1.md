# Step 1 — Wiring and Running the Simulation

In this step, we will design the virtual hardware for our IoT device. Before writing any code, we must understand how to connect our sensors and actuators to the ESP32.

### 1. The Hardware Components

We are using three main components in our simulation:
*   **ESP32 DevKit V1**: Our device's brain;
*   **DHT22**: A digital sensor that measures temperature and humidity;
*   **LED**: A simple light-emitting diode that will act as our indicator for the actuator state.

### 2. Understanding the Wiring

As you may already know, components need power and a way to communicate data:

*   **Power (VCC/3V3 & GND)**: Every component needs a complete circuit. We connect the **VCC** (Power) of the DHT22 to the **3V3** pin of the ESP32, and all **GND** (Ground) pins together.
*   **Data (SDA/GPIO 15)**: The DHT22 sends data using a single-wire protocol. We connect its **SDA** pin to **GPIO 15**. Our code will be configured to listen specifically on this pin.
*   **Actuation (GPIO 2)**: The LED is connected to **GPIO 2**. By setting this pin to `HIGH` (3.3V) or `LOW` (0V), the ESP32 can turn the light on or off. We connect the Anode (A) to the pin and the Cathode (C) to Ground.

### 3. Copying the Diagram to the Killercoda environment

In case you are exclusively using the Wokwi web editor, following the above instructions and visually connecting the various pins should be enough to get you started. If, however, you have to use the `wokwi-cli` to simulate your IoT device, you can take the content of the `diagram.json` file in the web editor and copy it over to `/root/esp32-iot/diagram.json` in the Killercoda environment and you should be set.

Please also note that, if you are following this exercise using the CLI, you will have to work with the `device.ino` file in the `/root/esp32-iot/src` folder, as it serves the exact same purpose of the `sketch.ino` file in the web editor.
