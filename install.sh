#!/bin/bash

if ! command -v docker &> /dev/null
then
    echo "Docker is not installed. Installing Docker..."
    curl -fsSL https://get.docker.com/ | CHANNEL=stable sudo bash

    if ! command -v docker &> /dev/null
    then
        echo "Failed to install Docker. Please install Docker manually."
        exit 1
    fi
fi

if ! command -v node &> /dev/null
then
    echo "Node.js is not installed. Installing Node.js..."
    sudo apt update
    sudo apt install -y nodejs npm

    if ! command -v node &> /dev/null
    then
        echo "Failed to install Node.js. Please install Node.js manually."
        exit 1
    fi
fi

# download and install duckynet 
echo "Downloading Duckynet..."
curl -L https://github.com/Ducky-Net/backend/archive/main.tar.gz -o duckynet.tar.gz

echo "Extracting Duckynet..."
tar -xzf duckynet.tar.gz && rm duckynet.tar.gz


echo "Installing Duckynet..."
mv backend-main duckynet
cd duckynet

npm install

echo "Configuring Duckynet..."

# update the path in config.json
sed -i "s|/home/duckynet|$(pwd)|g" config.json

# download and configure the path in service file
curl -L https://raw.githubusercontent.com/Ducky-Net/installer/main/duckynet.service -o duckynet.service
sed -i "s|/home/duckynet|$(pwd)|g" duckynet.service

sudo mv duckynet.service /etc/systemd/system/duckynet.service

systemctl enable --now duckynet
