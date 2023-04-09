#!/usr/bin/env bash

JVM_DIR_PATH=/usr/lib/jvm
JAVA_DIR_PATH=$JVM_DIR_PATH/java-18-openjdk-amd64

if [[ ! -e $JAVA_DIR_PATH ]]; then
    echo "jvm not installed"
elif [[ ! -d $JAVA_DIR_PATH ]]; then
    echo "$JAVA_DIR_PATH already exists but is not a directory" 1>&2
    exit 0
elif [[ -d $JAVA_DIR_PATH ]]; then
    echo "$JAVA_DIR_PATH already exists."
    exit 0
fi

#echo y | sudo apt purge openjdk-18-*

sudo NEEDRESTART_MODE=a apt-get dist-upgrade --yes

#sudo apt-get update
#echo y | sudo apt-get upgrade
echo y | sudo apt install openjdk-18-jdk

if [ -n ${JAVA_HOME} ]; then
    if [ "$(uname)" == "Darwin" ]; then
        # Export JAVA_HOME everytime we open a login shell.
        echo "export JAVA_HOME=$(dirname $(readlink $(which java)))" >> ~/.bash_profile
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
        # Export JAVA_HOME everytime we open a login shell.
        echo "export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))" >> ~/.bash_profile
    fi
        echo "export PATH=$PATH:$JAVA_HOME/bin" >> ~/.bash_profile
        source ~/.bash_profile
fi

# Verify installation
java -version
echo $JAVA_HOME

