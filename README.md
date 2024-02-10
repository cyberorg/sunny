# Sunrise-Sunset Cron Helper

This Bash script serves as a cron helper for executing a command only during the period between sunrise and sunset at a specified location.

## Usage

1. Ensure you have Bash and the `jq` tool installed on your system.
2. Set your latitude, longitude, and timezone details in the script.
3. Run the script using `bash sunny.sh && your_program` to execute `your_program` only during the period between sunrise and sunset.

## Configuration

- **Latitude and Longitude**: Specify your geographical coordinates (latitude and longitude) in the script where you want to check the sunrise and sunset times.
- **Timezone**: Adjust the timezone difference from UTC in the `TZD` variable. For example, if your timezone is UTC+5:30, set `TZD="5 hours 30 minutes"`.
- **Extension Period**: The period can be extended on either or both sides by adjusting the `TBSR` (time before sunrise) and `TBSS` (time after sunset) variables in seconds.

## Example

```bash
bash sunrise_sunset_cron.sh && your_program
