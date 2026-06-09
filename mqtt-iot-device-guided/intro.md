# Introduction

In this exercise, you will explore a complete IoT (Internet of Things) ecosystem consisting of two main components:

1.  **The IoT Device (ESP32)**: A microcontroller that reads environmental data (temperature and humidity) and publishes it to a cloud broker. It also listens for commands from a remote server to control an actuator (like an air conditioner) that - in this case - is simulated by a simple LED.
2.  **The IoT Controller (Python)**: A backend script that monitors the sensor data and sends "ON/OFF" commands to the device based on predefined thresholds, sketching how a system can be controlled remotely by using arbitrary rules.

### Architecture Overview

```text
[ ESP32 Device ] <---(MQTT)---> [ MQTT Broker ] <---(MQTT)---> [ Python Controller ]
   (Sensors)                                                     (Logic/Automation)
```

We will use the **MQTT** protocol, a lightweight messaging protocol perfect for IoT.

### Simulation with Wokwi

Since we don't have physical hardware, we will use **Wokwi**, a powerful online electronics simulator; you can open it by visiting [its web page](https://wokwi.com/projects/new/esp32).

Please note that while you are encouraged to try and use the web editor to follow along these instruction - as the build server can sometimes be too busy to accept new jobs from free accounts - this Killercoda environment is already set up with `wokwi-cli`, a tool that allows you to simulate the ESP32 from the commandline.

To get started, open the `/root/esp32-iot` folder to check how the project is structured; in theory, you'll only have to directly edit the `src/device.ino` file.

### Objectives

*   Understand how an ESP32 connects to Wi-Fi and an MQTT Broker.
*   Learn how to publish sensor data to specific topics.
*   Implement a remote control mechanism using subscriptions.
*   Build a Python automation script using the `paho-mqtt` library.

Click **Continue** to start setting up the environment.
