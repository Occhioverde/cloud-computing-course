# Step 6 — Python Controller: Automation Logic

The "Brain" of our system is the `on_message` callback in Python, as this is where we process incoming data and decide whether to trigger an alarm (the LED).

### Managing State

Since temperature and humidity arrive in separate messages at different times, we need to remember the last known values. For semplicity, in this script we'll use a couple of `global` variables:

```python
# --- Thresholds ---
TEMP_THRESHOLD = 30.0
HUM_THRESHOLD = 70.0

# --- State Variables ---
current_temp = 0.0
current_hum = 0.0
```

### The Logic Engine

Every time a message arrives from the ESP32 this function executes, performing three main tasks: **Decoding**, **Updating**, and **Evaluating**.

```python
def on_message(client, userdata, msg):
    global current_temp, current_hum

    # 1. Decoding: Data arrives as bytes, we need it as a UTF-8 string
    payload_str = msg.payload.decode('utf-8')

    try:
        # 2. Updating: Check which topic arrived and update our "memory"
        if msg.topic == TOPIC_TEMP:
            current_temp = float(payload_str)
            print(f"[RX] Temperature updated: {current_temp}°C")
        elif msg.topic == TOPIC_HUM:
            current_hum = float(payload_str)
            print(f"[RX] Humidity updated: {current_hum}%")

        # 3. Evaluating: Apply the business rule
        # If EITHER temperature OR humidity is too high, turn the LED ON
        if current_temp > TEMP_THRESHOLD or current_hum > HUM_THRESHOLD:
            print(f"   >>> ALERT! Threshold exceeded. Sending ON command.")
            client.publish(TOPIC_LED, "ON")
        else:
            # Otherwise, keep it OFF
            client.publish(TOPIC_LED, "OFF")

    except ValueError:
        # If someone sends "Hello" instead of "25.5", we catch the error here
        print(f"Received malformed data on {msg.topic}: {payload_str}")
```
