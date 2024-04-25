<#
.SYNOPSIS
This script tests a POP3 connection using specified credentials and sends a Telegram notification if authentication fails.

.DESCRIPTION
Test-POP3Connection.ps1 attempts to establish a secure SSL/TLS connection to a POP3 server, authenticates with given user credentials, and checks for successful authentication. If the authentication fails, the script sends an alert message through Telegram to a specified chat. The script uses TCP and SSL streams to connect and communicate with the server.

.PARAMETERS
- server: POP3 server address.
- port: Server port (typically 995 for POP3 over SSL).
- user: Username for POP3 login.
- password: Password for POP3 login.
- botToken: Telegram bot token for sending messages.
- chatID: Telegram chat ID where alerts will be sent.

.EXAMPLE
PS> .\Test-POP3Connection.ps1

.AUTHOR
Aviad Ofek

.NOTES
Ensure PowerShell execution policies and internet access settings permit the operation of this script.
#>

# Define connection parameters
$server = "pop3.R1.SERVER.net"
$port = 995
$user = "user"
$password = "password123"

# Define Telegram notification parameters
$botToken = "0000000000:00000-00000000000000000000000000000"  # Replace with your actual bot token
$chatID = "-0000000000000"                                    # Replace with your actual chat ID
$apiURL = "https://api.telegram.org/bot$botToken/sendMessage"

# Enforce using TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Function to send Telegram message
function Send-TelegramMessage {
    param($chatID, $message)
    
    $body = @{
        chat_id = $chatID
        text = $message
        parse_mode = "HTML"
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri $apiURL -Method 'POST' -Body $body -ContentType "application/json"
}

# Function to check POP3 connection
function Test-Pop3Connection {
    param($server, $port, $user, $password)

    # Set up TCP client and connect
    $tcpClient = New-Object System.Net.Sockets.TcpClient
    $tcpClient.Connect($server, $port)
    $sslStream = New-Object System.Net.Security.SslStream($tcpClient.GetStream(), $false, {
        param($sender, $certificate, $chain, $sslPolicyErrors)
        return $true  # Accept all certificates
    })
    
    # Authenticate with SSL
    $sslStream.AuthenticateAsClient($server)
    $reader = New-Object System.IO.StreamReader $sslStream
    $writer = New-Object System.IO.StreamWriter $sslStream
    
    # Read welcome message
    $welcome = $reader.ReadLine()
    Write-Host "Server Response: $welcome"
    
    # Send user name
    $writer.WriteLine("USER $user")
    $writer.Flush()
    $userResponse = $reader.ReadLine()
    Write-Host "USER command response: $userResponse"

    # Send password
    $writer.WriteLine("PASS $password")
    $writer.Flush()
    $passResponse = $reader.ReadLine()
    Write-Host "PASS command response: $passResponse"

    # Check if login is successful
    if ($passResponse -like '+OK*') {
        Write-Host "POP3 connection and authentication successful."
    } else {
        Write-Host "Failed to authenticate."
        Send-TelegramMessage -chatID $chatID -message "Failed to authenticate POP3. &#x1F534;"
    }

    # Close connection
    $writer.WriteLine("QUIT")
    $writer.Flush()
    $sslStream.Close()
    $tcpClient.Close()
}

# Call the function to test the connection
Test-Pop3Connection -server $server -port $port -user $user -password $password
