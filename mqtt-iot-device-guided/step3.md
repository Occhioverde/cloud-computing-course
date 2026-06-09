# Step 3 — ESP32: Publishing Sensor Data

Once the connection is established, our ESP32 is ready to start its primary job: monitoring the environment. We will read data from the **DHT22** sensor and "shout" it to the world through the MQTT broker.

### Defining our Channels (Topics)

In MQTT, data is organized into **topics**. Think of these as radio channels or folders in a filesystem. We define two separate topics to keep our temperature and humidity data distinct, adding them to our constants to have them ready for later:

```cpp
const char* topic_publish_temp = "iot_course/weather/temperature";
const char* topic_publish_hum  = "iot_course/weather/humidity";
```

### The "Pulse" of the Device: Non-blocking Loop

Let's now define the mainloop of our device, which will be responsible for three main tasks:

1. **Connectivity Check**: If we lose connection to the MQTT broker, we want to try reconnecting immediately;
2. **MQTT Maintenance**: The `client.loop()` function is essential to keep the MQTT connection alive and to process any incoming messages (like commands to control the LED);
3. **Periodic Sensor Reading**: Every 5 seconds, we want to read the temperature and humidity from the DHT22 and publish it to the corresponding MQTT topics.

To keep our device responsive, we avoid using `delay()`, as if we used `delay(5000)` the ESP32 would be "frozen" for 5 seconds and couldn't process incoming MQTT messages or send out the required ping/pongs.

Instead, we use a "pulse" logic with `millis()`:

```cpp
void loop() {
  // 1. Connectivity Check: If we lose connection, try to reconnect immediately using the function we defined earlier
  if (!client.connected())
    reconnect();
  
  // 2. MQTT Maintenance: This handles heartbeats and incoming packets
  client.loop(); 

  // 3. Periodic Task: Check if it's time to send new data
  unsigned long now = millis();
  if (now - lastMsg > 5000) { // Has it been 5 seconds since the last message?
    lastMsg = now;

    float t = dht.readTemperature();
    float h = dht.readHumidity();

    // Check if the reading is valid (the sensor might fail or be disconnected)
    if (!isnan(t) && !isnan(h)) {
      // MQTT only sends strings or bytes. We convert our float values:
      char tempString[8];
      dtostrf(t, 1, 2, tempString); // (value, width, precision, output_buffer)
      client.publish(topic_publish_temp, tempString);
      Serial.printf("Published Temperature: %s°C\n", tempString);

      char humString[8];
      dtostrf(h, 1, 2, humString);
      client.publish(topic_publish_hum, humString);
      Serial.printf("Published Humidity: %s%%\n", humString);
    }
  }
}
```
