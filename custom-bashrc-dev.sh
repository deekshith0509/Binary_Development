#!/bin/bash

# Configuration
CITY="Hyderabad"  # Change to your preferred city
API_KEY="25c97ed9fb1bb9e5768b3b12bbfe9137"  # Replace with your OpenWeatherMap API key

# Define color codes
COLOR_RESET="\033[0m"
COLOR_WELCOME="\033[1;35m"  # Magenta
COLOR_ASCI_ART="\033[1;33m"  # Bright Yellow
COLOR_CARTOON="\033[1;32m"  # Bright Green
COLOR_SYSINFO="\033[1;34m"  # Light Blue
COLOR_WEATHER="\033[1;36m"  # Light Cyan
COLOR_ANIMATION="\033[1;31m"  # Red

# Function to display an animated startup message
display_startup_animation() {
    clear
    local frames=(
        "   Initializing system...   "
        "   Loading components...    "
        "   Fetching data...         "
        "   Ready to go!            "
    )
    
    for frame in "${frames[@]}"; do
        clear
        printf "${COLOR_ANIMATION}%s${COLOR_RESET}\n" "$frame"
        sleep 1
    done

    clear
    printf "${COLOR_WELCOME}"
    figlet "Welcome!" | lolcat
    printf "${COLOR_RESET}"
    sleep 1
    cowsay -f tux "Let's get started!" | lolcat
    printf "${COLOR_RESET}"
    sleep 2
}

# Function to fetch weather data
fetch_weather() {
    local weather_data=$(curl -s "https://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$API_KEY&units=metric" | jq -r '.weather[0].description, .main.temp, .weather[0].icon')
    local description=$(echo "$weather_data" | head -n1)
    local temp=$(echo "$weather_data" | sed -n '2p')
    local icon_code=$(echo "$weather_data" | tail -n1)
    echo "$temp,$description"
}

# Function to display real-time weather with custom emojis
display_weather() {
    local weather_data
    weather_data=$(fetch_weather)
    local temp=$(echo "$weather_data" | cut -d',' -f1)
    local description=$(echo "$weather_data" | cut -d',' -f2)

    # Determine weather emoji based on description
    local emoji
    case "$description" in
        *clear*) emoji="☀️" ;;    # Clear sky
        *cloud*) emoji="☁️" ;;    # Clouds
        *rain*) emoji="🌧️" ;;    # Rain
        *snow*) emoji="🌨️" ;;    # Snow
        *thunderstorm*) emoji="⛈️" ;;  # Thunderstorm
        *haze*) emoji="🌫️" ;;    # Haze
        *mist*) emoji="🌫️" ;;    # Mist
        *fog*) emoji="🌁" ;;     # Fog
        *drizzle*) emoji="🌦️" ;; # Drizzle
        *) emoji="🌈" ;;         # Default
    esac

    printf "${COLOR_WEATHER}Weather:${COLOR_RESET}\n"
    printf "${COLOR_WEATHER}City:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$CITY"
    printf "${COLOR_WEATHER}Temperature:${COLOR_RESET} ${COLOR_RESET}%s°C${COLOR_RESET}\n" "$temp"
    printf "${COLOR_WEATHER}Description:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$description"
    printf "${COLOR_WEATHER}Icon:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$emoji"
}

# Function to display system information with colors
display_system_info() {
    printf "${COLOR_SYSINFO}System Info:${COLOR_RESET}\n"
    printf "${COLOR_SYSINFO}Hostname:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(hostname)"
    printf "${COLOR_SYSINFO}Kernel:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(uname -r)"
    printf "${COLOR_SYSINFO}Uptime:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(uptime -p)"
    printf "${COLOR_SYSINFO}CPU:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(lscpu | grep 'Model name' | awk -F: '{print $2}' | xargs)"
    printf "${COLOR_SYSINFO}Memory:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(free -h | grep Mem | awk '{print $3 "/" $2}')"
    printf "${COLOR_SYSINFO}Disk Usage:${COLOR_RESET} ${COLOR_RESET}%s${COLOR_RESET}\n" "$(df -h / | grep / | awk '{print $3 "/" $2}')"
}

# Function to display real-time weather with appropriate icon

# Function to display real-time weather with appropriate icon

# Function to display the ASCII art from `curl` and then show the welcome message
display_parrot_ascii() {
    local parrot_process

    # Start fetching the ASCII art in the background
    curl https://ascii.peanut.tf/parrot &
    parrot_process=$!

    # Wait for 3 seconds
    sleep 3

    # Kill the `curl` process
    kill $parrot_process 2>/dev/null

    # Clear the screen
    clear

    # Display the welcome message with an animated effect
    printf "${COLOR_WELCOME}"
    figlet "Welcome!" | lolcat
    printf "${COLOR_RESET}"
    sleep 1
    cowsay -f tux "Let's get started!" | lolcat
    printf "${COLOR_RESET}"
    sleep 2
}

# Function to display a Linux cartoon
display_linux_cartoon() {
    clear
    printf "${COLOR_CARTOON}"
    curl -s "https://ascii.co/api/v1/cartoons/linux" | lolcat
    printf "${COLOR_RESET}"
    sleep 3
}

# Function to display animated system info and weather
display_animated_info() {
    clear
    local delay=0.1
    local frames=(
        "   Loading system info...   "
        "   Fetching weather data...  "
        "   Almost there...           "
    )
    
    for frame in "${frames[@]}"; do
        clear
        printf "${COLOR_ANIMATION}%s${COLOR_RESET}\n" "$frame"
        sleep $delay
    done

    clear
    display_system_info
    echo ""
    display_weather
}

# Display the greeting message and ASCII art
display_startup_animation

# Display the Linux cartoon
display_linux_cartoon

# Display animated system info and weather
display_animated_info

# Exit the script
printf "\n${COLOR_WELCOME}Script has finished executing. Exiting...${COLOR_RESET}\n"
exit 0
