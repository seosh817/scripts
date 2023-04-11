#!/usr/bin/env bash

SDK_LINUX=https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
SDK_MAC=https://dl.google.com/android/repository/commandlinetools-mac-9477386_latest.zip

if [ ! -n ${JAVA_HOME} ]; then
        echo "\$JAVA_HOME environmental variable is not set."
        echo "Find the location of your Java directory, and then put it in your"
        echo "~/.bash_profile (or any other shell equivalent)"
        exit 0
fi

if [ "$(uname)" == "Darwin" ]; then
    cd /usr/lib
    curl "$SDK_MAC" -o androidsdk.zip
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    cd /usr/lib
    wget -O androidsdk.zip "$SDK_LINUX"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    echo "Unsupported OS"
    exit 0
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
    echo "Unsupported OS"
    exit 0
fi

if [[ -f androidsdk.zip ]]; then
    unzip -d ./android-sdk androidsdk.zip
    rm androidsdk.zip
fi

if [[ -d android-sdk ]]; then
    cd android-sdk/cmdline-tools
    mkdir tools
    mv -i * tools
    # Export environment variable everytime we open a login shell.
    echo "export ANDROID_HOME=$(pwd)" >> ~/.bash_profile
    echo "export PATH=$PATH:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator" >> ~/.bash_profile
    source ~/.bash_profile

    # Install the Android SDK
    cd tools/bin
    ./sdkmanager --list
    echo y | ./sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;33.0.1" "emulator"
fi

