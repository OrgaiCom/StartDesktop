#!/bin/bash

# Update package list
echo "Updating package list..."
sudo apt-get update -y

# Check if qutebrowser is installed
if ! command -v qutebrowser &> /dev/null
then
    echo "qutebrowser is not installed. Installing now..."
    sudo apt-get install -y qutebrowser
else
    echo "qutebrowser is already installed."
fi

# Launch qutebrowser with qt.force_software_rendering set to qt-quick
# The first argument to the script will be passed as the URL/file to open.
qutebrowser -s qt.force_software_rendering qt-quick "$1"
