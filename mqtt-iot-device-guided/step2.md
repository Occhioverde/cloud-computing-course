# Step 2 — ESP32: Wi-Fi, MQTT and DHT Connectivity

First things first, let's start our sketch by adding the libraries needed to make it work:

```cpp
#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>
```

These essentially expose the necessary functions to connect to Wi-Fi, interact with the MQTT broker, and read data from the DHT22 sensor.

Then, the ESP32 needs to connect to the internet to reach the MQTT broker. In our simulation we can use the virtual network provided by Wokwi, which has a predefined SSID and password, so let's start our firmware by defining these credentials along with the required objects:

```cpp
// Wi-Fi Configurations (Wokwi simulation credentials)
const char* ssid = "Wokwi-GUEST";
const char* password = "";

WiFiClient espClient;
```

Since we'll need them later, we can also define the parameters and objects needed to connect to the MQTT broker. In this case, we will use a free public broker provided by EMQX, which does not require authentication (but - as you can imagine - should not be used for production or sensitive data):

```cpp
// MQTT Broker Configurations (Using a free public broker)
const char* mqtt_broker = "broker.emqx.io";
const int mqtt_port = 1883;

// Unique Client ID (Important: Students must change this to avoid collisions!)
const char* client_id = "esp32_iot_course_student_abcd";

// MQTT Client
PubSubClient client(espClient);
```

**Note:** The `client_id` must be unique across the entire broker. If two devices use the same ID, the broker will kick the older one out, so be sure to change the `client_id` value before running the simulation to avoid conflicts with other students.

Last but not least, we define every variable related to the DHT and LED interaction:

```cpp
#define DHTPIN 15
#define DHTTYPE DHT22
#define LED_PIN 2

DHT dht(DHTPIN, DHTTYPE);
```

### The Connection Logic

Let's now implement the logic to connect to Wi-Fi and the MQTT broker. The `setup_wifi()` function will attempt to connect to the specified Wi-Fi network, printing dots every half second until it succeeds:

```cpp
void setup_wifi() {
  delay(10);
  Serial.print("Connecting to Wi-Fi...");
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWi-Fi Connected!");
}
```

To make our system even more resilient to network issues, let's also implement a `reconnect()` function that can be called in the main loop to ensure that the device is always connected to the MQTT broker. In case the connection should drop, we can keep trying to reconnect every 5 seconds:

```cpp
void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    if (client.connect(client_id)) {
      Serial.println("Connected to Broker!");
      // Subscribe to control topic
      client.subscribe(topic_subscribe_led);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      delay(5000);
    }
  }
}
```

### The Orchestrator: setup()

Finally, we use the standard Arduino `setup()` function to pull everything together. This function runs exactly **once** when the ESP32 powers on and initializes the hardware peripherals while preparing our libraries:

```cpp
void setup() {
  // 1. Initialize Serial communication for debugging
  Serial.begin(115200);

  // 2. Configure Pin modes (the LED pin must be an OUTPUT)
  pinMode(LED_PIN, OUTPUT);

  // 3. Initialize the DHT sensor library
  dht.begin();

  // 4. Run our Wi-Fi connection logic
  setup_wifi();
}
```
