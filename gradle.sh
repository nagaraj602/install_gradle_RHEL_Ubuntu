#!/bin/bash

distro=$(cat /etc/os-release | grep "^ID=" | cut -d "=" -f2 | sed 's/"//g')

echo
echo
echo
echo "Installing Gradle on $distro"

if [ "$distro" == "rhel" ]; then

    sudo yum update -y > /dev/null 2>&1
    sudo yum upgrade -y > /dev/null 2>&1
    sudo yum install wget unzip -y > /dev/null 2>&1
    sudo dnf install java-21-openjdk-devel -y > /dev/null 2>&1

elif [ "$distro" == "ubuntu" ]; then

    sudo apt-get update -y > /dev/null 2>&1
    sudo apt-get upgrade -y > /dev/null 2>&1
    sudo apt-get install wget unzip openjdk-21-jdk -y > /dev/null 2>&1

else
    echo "Unsupported Distribution - Only RHEL and Ubuntu are supported by this Script!!!!"
    exit 1
fi

# Dynamically detect JAVA_HOME
JAVA_HOME_PATH=$(dirname $(dirname $(readlink -f $(which javac))))

# Remove old Gradle if exists
sudo rm -rf /opt/gradle-* /opt/gradle /usr/local/bin/gradle > /dev/null 2>&1

cd /tmp

# Download Gradle
wget https://services.gradle.org/distributions/gradle-9.4.0-bin.zip > /dev/null 2>&1

if [ $? -ne 0 ]; then
    echo
    echo -e "ERROR: Gradle download failed due to outdated link! \nPlease update the correct link from Gradle official website."
    echo
    exit 1
fi

# Extract and setup
sudo unzip -o gradle-9.4.0-bin.zip -d /opt > /dev/null 2>&1
sudo ln -s /opt/gradle-9.4.0 /opt/gradle
sudo ln -s /opt/gradle/bin/gradle /usr/local/bin/gradle

# Environment variables
sudo tee /etc/profile.d/gradle.sh > /dev/null <<EOF
export JAVA_HOME=$JAVA_HOME_PATH
export GRADLE_HOME=/opt/gradle
export PATH=\${GRADLE_HOME}/bin:\${PATH}
EOF

sudo chmod +x /etc/profile.d/gradle.sh
source /etc/profile.d/gradle.sh

echo
echo "Gradle 9.4.0 installed successfully on $distro"
echo

