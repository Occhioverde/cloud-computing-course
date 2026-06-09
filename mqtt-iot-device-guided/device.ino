#include <WiFi.h>
#include <PubSubClient.h>
#include <DHT.h>

// Wi-Fi Configurations (Wokwi simulation credentials)
const char* ssid = "Wokwi-GUEST";
const char* password = "";

// MQTT Broker Configurations (Using a free public broker)
const char* mqtt_broker = "broker.emqx.io";
const int mqtt_port = 1883;

// Unique Client ID (Important: Students must change this to avoid collisions!)
const char* client_id = "esp32_iot_course_student_abcd";

// MQTT Topics
const char* topic_publish_temp = "iot_course/weather/temperature";
const char* topic_publish_hum  = "iot_course/weather/humidity";
const char* topic_subscribe_led = "iot_course/weather/led_control";

#define DHTPIN 15
#define DHTTYPE DHT22
#define LED_PIN 2

DHT dht(DHTPIN, DHTTYPE);
WiFiClient espClient;
PubSubClient client(espClient);

unsigned long lastMsg = 0;

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

void callback(char* topic, byte* payload, unsigned int length) {
  Serial.print("Message arrived on topic: ");
  Serial.print(topic);
  Serial.print(". Message: ");

  String messageTemp;
  for (int i = 0; i < length; i++) {
    messageTemp += (char)payload[i];
  }
  Serial.println(messageTemp);

  // Control LED based on incoming MQTT message
  if (String(topic) == topic_subscribe_led) {
    if (messageTemp == "ON") {
      digitalWrite(LED_PIN, HIGH);
      Serial.println("LED turned ON");
    } else if (messageTemp == "OFF") {
      digitalWrite(LED_PIN, LOW);
      Serial.println("LED turned OFF");
    }
  }
}

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
      Serial.println(" trying again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
  dht.begin();

  setup_wifi();
  client.setServer(mqtt_broker, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Publish sensor data every 5 seconds
  unsigned long now = millis();
  if (now - lastMsg > 5000) {
    lastMsg = now;

    float t = dht.readTemperature();
    float h = dht.readHumidity();

    if (!isnan(t) && !isnan(h)) {
      char tempString[8];
      dtostrf(t, 1, 2, tempString);
      client.publish(topic_publish_temp, tempString);
      Serial.printf("Published Temperature: %s°C\n", tempString);

      char humString[8];
      dtostrf(h, 1, 2, humString);
      client.publish(topic_publish_hum, humString);
      Serial.printf("Published Humidity: %s%%\n", humString);
    }
  }
}
