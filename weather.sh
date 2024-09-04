#!/bin/bash

# API key for OpenWeatherMap
API_KEY="25c97ed9fb1bb9e5768b3b12bbfe9137"

# Function to fetch current weather conditions for a given city
fetch_weather() {
    local city_name="$1"
    local city_weather=$(curl -s "http://api.openweathermap.org/data/2.5/weather?q=${city_name}&appid=${API_KEY}&units=metric")

    # Check if the city name is valid
    if echo "$city_weather" | jq -e '.cod == 200' > /dev/null; then
        # Extracting weather details using jq
        local weather_description=$(echo "$city_weather" | jq -r '.weather[0].description // "Data not available"')
        local temperature=$(echo "$city_weather" | jq -r '.main.temp // "Data not available"')
        local feels_like=$(echo "$city_weather" | jq -r '.main.feels_like // "Data not available"')
        local temp_min=$(echo "$city_weather" | jq -r '.main.temp_min // "Data not available"')
        local temp_max=$(echo "$city_weather" | jq -r '.main.temp_max // "Data not available"')
        local pressure=$(echo "$city_weather" | jq -r '.main.pressure // "Data not available"')
        local humidity=$(echo "$city_weather" | jq -r '.main.humidity // "Data not available"')
        local visibility=$(echo "$city_weather" | jq -r '.visibility // "Data not available"')
        local wind_speed=$(echo "$city_weather" | jq -r '.wind.speed // "Data not available"')
        local wind_deg=$(echo "$city_weather" | jq -r '.wind.deg // "Data not available"')
        local clouds=$(echo "$city_weather" | jq -r '.clouds.all // "Data not available"')
        local sunrise=$(echo "$city_weather" | jq -r '.sys.sunrise // "Data not available"')
        local sunset=$(echo "$city_weather" | jq -r '.sys.sunset // "Data not available"')
        local timezone=$(echo "$city_weather" | jq -r '.timezone // "Data not available"')
        local dt=$(echo "$city_weather" | jq -r '.dt // "Data not available"')
        local name=$(echo "$city_weather" | jq -r '.name // "Data not available"')
        local country=$(echo "$city_weather" | jq -r '.sys.country // "Data not available"')

        # Convert timestamps to local time
        if [[ "$sunrise" != "Data not available" && "$sunset" != "Data not available" && "$dt" != "Data not available" ]]; then
            local local_sunrise=$(date -d "@$((sunrise + timezone))" +'%Y-%m-%d %H:%M:%S')
            local local_sunset=$(date -d "@$((sunset + timezone))" +'%Y-%m-%d %H:%M:%S')
            local local_dt=$(date -d "@$dt" +'%Y-%m-%d %H:%M:%S')
        else
            local_sunrise="N/A"
            local_sunset="N/A"
            local_dt="N/A"
        fi

        # Displaying weather information
        echo "-----------------------------------"
        echo "Weather Information for $name, $country:"
        echo "Weather Description: $weather_description"
        echo "Temperature: $temperature°C"
        echo "Feels Like: $feels_like°C"
        echo "Minimum Temperature: $temp_min°C"
        echo "Maximum Temperature: $temp_max°C"
        echo "Pressure: $pressure hPa"
        echo "Humidity: $humidity%"
        echo "Visibility: $visibility meters"
        echo "Wind Speed: $wind_speed m/s"
        echo "Wind Degree: $wind_deg°"
        echo "Cloudiness: $clouds%"
        echo "Sunrise: $local_sunrise (Local Time)"
        echo "Sunset: $local_sunset (Local Time)"
        echo "Timezone: $timezone seconds"
        echo "Data Time: $local_dt (Local Time)"
        echo "-----------------------------------"
    else
        echo "City not found. Please check the city name and try again."
        echo "Tips:"
        echo "- Ensure the city name is spelled correctly."
        echo "- Make sure the city exists in the OpenWeatherMap database."
        echo "- Try using a different city name or verify the city name."
    fi
}

# Main script
if [ "$#" -gt 0 ]; then
    # If an argument is provided, use it as the city name
    city_name="$1"
else
    # If no argument is provided, prompt the user for input
    read -p "Enter city name: " city_name
fi

# Ensure the city name is not empty
if [ -z "$city_name" ]; then
    echo "City name cannot be empty. Exiting."
    exit 1
fi

# Fetch and display weather for the specified city
fetch_weather "$city_name"
