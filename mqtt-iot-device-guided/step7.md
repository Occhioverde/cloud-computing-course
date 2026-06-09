# Step 7 — Integration and Testing

It's time to see the whole system in action. You will run the **Python Controller** in this terminal and the **ESP32 Simulator** in the Wokwi tab.

### 1. Launch the Controller

In the main terminal, start the Python script. It will connect to the EMQX broker and wait for sensor data.

```bash
python3 /root/controller.py
```{{exec}}

You should see: `Attempting to connect to broker.emqx.io...` followed by `Connected to MQTT Broker successfully!`.

### 2. Interact with the ESP32

Now, switch to the **Wokwi Simulation** tab (which you launched in Step 1). 

1.  **Wait for Connection**: Look at the "Serial Monitor" in the simulation. It should show `Wi-Fi Connected!` and then `Connected to Broker!`.
2.  **Monitor Data**: Every 5 seconds, you will see `Published Temperature: ...` in the simulation logs.
3.  **Check the Controller**: Look back at this terminal. You should see `[RX] Temperature updated: ...` messages appearing.
4.  **Trigger the Alarm**: 
    *   In the Wokwi simulator, click on the **DHT22** sensor.
    *   A slider will appear. Move the temperature slider above **30°C**.
5.  **Observe the Command**:
    *   The Controller terminal will print `>>> ALERT! Threshold exceeded. Sending ON command.`
    *   The Wokwi simulation will print `Action: LED turned ON` and you will see the **red LED light up** on the diagram!

### 3. Clear the Alarm

Move the slider back below 30°C (and ensure humidity is below 70%). The Controller will send the `OFF` command, and the virtual LED will turn off.

### Troubleshooting
*   **No data?** Check that both the ESP32 and the Python script are using the same MQTT topics.
*   **LED doesn't turn on?** Ensure the `client_id` in `device.ino` is unique to you. If someone else is using the same ID, the broker will disconnect you!
*   **Can't see the Wokwi tab?** Ensure you ran `wokwi-cli /root/esp32-iot` in Step 1.

When you are finished, you can stop the Python controller with `Ctrl+C`.
