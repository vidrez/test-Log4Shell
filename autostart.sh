#!/bin/bash

screen -AmdS mserver java -Xmx1024M -Xms1024M -jar ./minercfat-server/server.jar nogui
screen -AmdS dockerpoc docker run --network host log4j-shell-poc
