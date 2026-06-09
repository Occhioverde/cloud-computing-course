import paho.mqtt.client as mqtt

# --- Configuration ---
BROKER = "broker.emqx.io"
PORT = 1883

# Ensure these match the ESP32 code perfectly
TOPIC_TEMP = "iot_course/weather/temperature"
TOPIC_HUM = "iot_course/weather/humidity"
TOPIC_LED = "iot_course/weather/led_control"

# --- Thresholds ---
# If temperature goes above 30C OR humidity goes above 70%, turn on the LED
TEMP_THRESHOLD = 30.0
HUM_THRESHOLD = 70.0

# --- State Variables ---
# We use these to remember the last received values
current_temp = 0.0
current_hum = 0.0

# --- Callbacks ---
def on_connect(client, userdata, flags, reason_code, properties):
    if reason_code == 0:
        print("Connected to MQTT Broker successfully!")
        # Subscribe to both sensor topics upon connecting
        client.subscribe([(TOPIC_TEMP, 0), (TOPIC_HUM, 0)])
        print(f"Listening to {TOPIC_TEMP} and {TOPIC_HUM}...\n")
    else:
        print(f"Failed to connect, return code {reason_code}")

def on_message(client, userdata, msg):
    global current_temp, current_hum

    # Decode the payload from bytes to a string
    payload_str = msg.payload.decode('utf-8')

    try:
        # 1. Update our state variables based on which topic arrived
        if msg.topic == TOPIC_TEMP:
            current_temp = float(payload_str)
            print(f"[RX] Temperature updated: {current_temp}°C")
        elif msg.topic == TOPIC_HUM:
            current_hum = float(payload_str)
            print(f"[RX] Humidity updated: {current_hum}%")

        # 2. Evaluate the automation rules
        if current_temp > TEMP_THRESHOLD or current_hum > HUM_THRESHOLD:
            print(f"   >>> ALERT! Threshold exceeded. Sending ON command.")
            client.publish(TOPIC_LED, "ON")
        else:
            print(f"   >>> Values normal. Sending OFF command.")
            client.publish(TOPIC_LED, "OFF")

    except ValueError:
        print(f"Received malformed data on {msg.topic}: {payload_str}")

# --- Main Program Execution ---
if __name__ == "__main__":
    # Initialize the client (using the modern v2 Callback API)
    client = mqtt.Client(mqtt.CallbackAPIVersion.VERSION2)

    # Assign the event callbacks
    client.on_connect = on_connect
    client.on_message = on_message

    # Connect to the broker
    print(f"Attempting to connect to {BROKER}...")
    client.connect(BROKER, PORT, 60)

    # Start the network loop (this blocks forever, waiting for messages)
    try:
        client.loop_forever()
    except KeyboardInterrupt:
        print("\nDisconnecting from broker...")
        client.disconnect()
        print("Exited cleanly.")
