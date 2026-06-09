# Step 4 — ESP32: Receiving Commands (LED Control)

An IoT device isn't just a sensor; it's often an **actuator** that can respond to the physical world. In this step, we'll teach the ESP32 to "listen" for commands to control its attached device.

### The Callback: Dealing with Asynchronous Data

Since we don't know *when* a command will arrive, we define a **callback function** that the MQTT library will call every time a new message is received on a topic we are subscribed to. This function will receive the topic, the payload (the actual message), and its length as parameters:

```cpp
void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("]: ");

  // The payload arrives as a byte array, so we convert it to a String for easy comparison
  String messageTemp;
  for (int i = 0; i < length; i++) {
    messageTemp += (char)payload[i];
  }
  Serial.println(messageTemp);

  // Check if the message arrived on our specific control topic
  if (String(topic) == "iot_course/weather/led_control") {
    if (messageTemp == "ON") {
      digitalWrite(LED_PIN, HIGH); // Turn the LED on
      Serial.println("Action: LED turned ON");
    } else if (messageTemp == "OFF") {
      digitalWrite(LED_PIN, LOW);  // Turn the LED off
      Serial.println("Action: LED turned OFF");
    }
  }
}
```

### Hooking it Up

For this callback to work, we'll need to do two things in our `setup()` function:

1.  **Register the callback**: Tell the library which function to use.
2.  **Subscribe**: Tell the broker we want to receive messages from a specific "channel".

```cpp
void setup() {
  // ... the other setup code ...
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback); // Registering our function
}
```

### Starting the simulation

If you are working with the Wokwi simulator, you should now be ready to start the simulation by simply pressing the green play button; the ESP32 will connect to the MQTT broker and wait for commands.

If you are using the `wokwi-cli` tool, however, make sure you have the terminal open in the `esp32-iot` directory and run the following commands to start the simulation:

```bash
/root/.platformio/penv/bin/pio run
/root/.wokwi/bin/wokwi-cli
```

If it asks you for a token, make sure to follow the provided instructions and then re-run `wokwi-cli` to start the simulation. You should see the ESP32 connecting to Wi-Fi and then to the MQTT broker in the logs. The device will now be ready to receive commands, which we will send from our Python controller in the next step!
