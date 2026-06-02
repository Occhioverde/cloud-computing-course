# Step 5 - Create and query a database via Mongo Express

Now that your MongoDB stack is fully deployed, let's put it to use! Instead of using the command line, this time we will use the **Mongo Express** web interface you just deployed.

### The Challenge: IoT Telemetry

Your task is to set up a database to store telemetry data from a new fleet of weather stations and query it using the web UI.

1.  **Access Mongo Express:** Open the Mongo Express dashboard (<{{TRAFFIC_HOST1_30081}}>).
2.  **Create the Database and Collection:**
    *   From the main page, create a new database named `iot_telemetry`.
    *   Inside that database, create a new collection named `weather_readings`.
3.  **Insert Complex Data:**
    *   Navigate into your new collection and use the "New Document" feature to insert the following three documents. *Note: Mongo Express requires strict JSON format, so make sure your keys are in double quotes!*

    **Document 1:**
    ```json
    {
      "station_id": "WS-01",
      "location": "North Roof",
      "metrics": { "temperature": 22.5, "humidity": 45 },
      "status": "active"
    }
    ```
    **Document 2:**
    ```json
    {
      "station_id": "WS-02",
      "location": "South Garden",
      "metrics": { "temperature": 27.1, "humidity": 60 },
      "status": "active"
    }
    ```
    **Document 3:**
    ```json
    {
      "station_id": "WS-03",
      "location": "East Gate",
      "metrics": { "temperature": 19.8, "humidity": 55 },
      "status": "maintenance"
    }
    ```

4.  **Query the Data:**
    * Open the "Advanced" search view;
    * Construct and execute a JSON query to find only the **active** stations where the **temperature is strictly greater than 25**.

**Expected outcome:**
- Your query should return exactly 1 document (`WS-02`).
