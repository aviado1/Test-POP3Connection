# POP3 Connection Test Script

This PowerShell script tests a POP3 connection using specified credentials and sends a Telegram alert if authentication fails. It includes handling for secure connections and is useful for monitoring the integrity of email server access.

## Features

- **Connects to POP3 server using SSL/TLS**: Ensures secure communication with the POP3 server.
- **Authenticates using provided credentials**: Verifies user credentials for access.
- **Sends a Telegram message if authentication fails**: Alerts the user via Telegram about authentication failures.

## Requirements

- **PowerShell 5.0 or higher**: Needed to execute the script.
- **Internet access**: Required for sending Telegram notifications.
- **Access to a POP3 server with SSL/TLS**: Necessary for testing the connection.

## Setup

1. Replace the placeholders in the script with your actual POP3 server details and credentials.
2. Set up your Telegram bot token and chat ID to receive alerts.

## Author

This script was authored by [aviado1](https://github.com/aviado1).

## Disclaimer

This script is provided "as is", without warranty of any kind, express or implied. The author is not responsible for any damages or losses caused by using this script. Users are encouraged to test the script in a development environment before deploying it in a production environment.

## Contributing

Feedback and contributions are welcome. Please feel free to fork the repository, make improvements, and submit pull requests.



## Usage

To run the script, execute it from a PowerShell command line:

```powershell
.\Test-POP3Connection.ps1

