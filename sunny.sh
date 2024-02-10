#!/bin/bash
#Author: cyberorg - jigish.gohil@gmail.com

# Latitude and Longitude, for example, get it from here: https://www.latlong.net/
latitude="32.0456"
longitude="76.7236"
# Time zone difference from UTC
TZD="5 hours 30 minutes"
# Time before sunrise and after sunset to permit, in seconds
TBSR=600
TBSS=600
# Get today's date in IST
today=$(TZ="Asia/Kolkata" date +%Y-%m-%d)

# Remove temp files that don't match today's date
remove_oldtemp() {
    for tempfile in $(ls /tmp/sunrise_sunset_* 2>/dev/null); do
        filename=$(basename "$tempfile")
        filedate=${filename#sunrise_sunset_}
        if [ "$filedate" != "$today" ]; then
            rm "$tempfile"
        fi
    done
}
ls /tmp/sunrise_sunset_* > /dev/null 2>/dev/null && remove_oldtemp

# Function to fetch sunrise and sunset times and save them to a file
fetch_save_times() {
    # Get sunrise and sunset times
    response=$(curl -s "https://api.sunrise-sunset.org/json?lat=$latitude&lng=$longitude&date=$today")
    sunrise=$(echo "$response" | jq -r '.results.sunrise')
    sunset=$(echo "$response" | jq -r '.results.sunset')

    # Add 5 hours 30 minutes to sunrise and sunset times
    sunrise=$(date -d "$sunrise +$TZD" +"%Y-%m-%d %H:%M:%S")
    sunset=$(date -d "$sunset +$TZD" +"%Y-%m-%d %H:%M:%S")

    # Convert sunrise and sunset time to timestamp
    sunrise_timestamp=$(date -d "$sunrise" +%s)
    sunset_timestamp=$(date -d "$sunset" +%s)

    # Seconds before sunrise and after sunset
    minus_from_sunrise=$(date -d "@$((sunrise_timestamp - $TBSR))" +"%H:%M:%S")
    add_to_sunset=$(date -d "@$((sunset_timestamp + $TBSS))" +"%H:%M:%S")

    # Write to temp file with date stamp
    echo "$minus_from_sunrise" > "/tmp/sunrise_sunset_$today"
    echo "$add_to_sunset" >> "/tmp/sunrise_sunset_$today"
}

# Check if temp file exists for today's date
temp_file="/tmp/sunrise_sunset_$today"
if [ -f "$temp_file" ]; then
    # Read values from temp file
    minus_from_sunrise=$(head -n 1 "$temp_file")
    add_to_sunset=$(tail -n 1 "$temp_file")
else
    # Fetch and save times
    fetch_save_times
fi

# Get current time in IST
current_time=$(TZ="Asia/Kolkata" date +"%H:%M:%S")

# Compare current time with adjusted sunrise and sunset times
if [[ "$current_time" < "$minus_from_sunrise" || "$current_time" > "$add_to_sunset" ]]; then
    echo "OOT."
    exit 1
fi
