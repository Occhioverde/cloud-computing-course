# Step 5 — Python Controller: MQTT Client Setup

Now that our device is sending data, we need a **Controller** to listen to that data and make decisions. We'll use Python for this, specifically the `paho-mqtt` library.

Everything you need to follow these instructions is already available on this Killercoda instance, so you can simply open the `controller.py` file in the `/root/backend-controller` folder and start coding. To run the script, you can use the terminal and execute:

```bash
source .venv/bin/activate
python controller.py
```

### Modern MQTT with Python

Like the ESP32 library, the `paho-mqtt` library uses a structured "Callback API" that allows us to asynchronously handle incoming messages. We start by defining our connection parameters, matching exactly what we used in the ESP32 code:

```python
import paho.mqtt.client as mqtt

BROKER = "broker.emqx.io"
PORT = 1883

# These MUST match the ESP32 constants
TOPIC_TEMP = "iot_course/weather/temperature"
TOPIC_HUM = "iot_course/weather/humidity"
TOPIC_LED = "iot_course/weather/led_control"
```

### The "On Connect" Handshake

Just like in C++, we use a callback to handle the connection event. This function runs automatically once the network handshake is complete, so it's the perfect place to **subscribe** to the sensor topics:

```python
def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code == 0:
        print("Connected to MQTT Broker successfully!")
        # We subscribe to a LIST of tuples: (topic, QoS)
        # QoS 0 means "Fire and forget" - the fastest delivery method
        client.subscribe([(TOPIC_TEMP, 0), (TOPIC_HUM, 0)])
        print(f"Listening to {TOPIC_TEMP} and {TOPIC_HUM}...\n")
    else:
        print(f"Failed to connect, return code {reason_code}")
```

### Initializing the Client

In the main block of our script, we create the client instance using the `VERSION2` API, assign our callback, and start the networking loop:

```python
if __name__ == "__main__":
    # 1. Create the client instance
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    # 2. Assign the event callbacks
    client.on_connect = on_connect
    client.on_message = on_message # We'll define this logic in the next step

    # 3. Connect and loop
    print(f"Attempting to connect to {BROKER}...")
    client.connect(BROKER, PORT, 60)

    try:
        # loop_forever() is a blocking call that handles all MQTT traffic
        client.loop_forever()
    except KeyboardInterrupt:
        print("\nDisconnecting...")
        client.disconnect()
```

The `loop_forever()` call is crucial: it keeps the script running, waiting for messages, and automatically handles pings to keep the connection alive.
