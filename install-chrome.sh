#!/bin/bash

# Define the download URL and filename
DOWNLOAD_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
DEB_FILE="google-chrome-stable_current_amd64.deb"

# Download the Google Chrome .deb package
echo "Downloading Google Chrome..."
wget -q "$DOWNLOAD_URL" -O "$DEB_FILE"

# Check if the download was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to download Google Chrome."
    exit 1
fi

# Install the package and its dependencies
echo "Installing Google Chrome..."
# Update package list first
sudo apt-get update
sudo apt-get install -y ./"$DEB_FILE"

# Check if the installation was successful
if [ $? -ne 0 ]; then
    echo "Error: Failed to install Google Chrome. Trying to fix dependencies..."
    # Try to fix broken dependencies
    sudo apt-get install -f -y
    if [ $? -ne 0 ]; then
        echo "Error: Could not fix dependencies. Installation failed."
        # Clean up the downloaded file
        rm -f "$DEB_FILE"
        exit 1
    fi
fi

# Clean up the downloaded file
echo "Cleaning up..."
rm -f "$DEB_FILE"

echo "Google Chrome installed successfully."
exit 0
