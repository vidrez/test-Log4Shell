# Setup Testing Environment for log4Shell Vulnerability (CVE-2021-44228)

**The execution of this script was tested only on Ubuntu Server 22.04**

The script will setup a vulnerable version of:

* Minecraft Server 1.18
* Apache Solr 8.11.0
* A Vulnerable Proof-of-concept (POC) Web App made by [kozmer](https://github.com/kozmer/log4j-shell-poc)  

## Instructions

Add executable permissions to the script:

```
sudo chmod +x setup-log4Shell.sh
```

Execute the script with root privileges:

```
sudo ./setup-log4Shell.sh
```

**The addresses of the installed applications will be shown at the end of the script**

## Autorestart (optional)

To autorestart the docker web app and the minecraft server on system startup/reboot you can add the *autostart.sh* script as a reboot cron by:

1. Set *autostart.sh* executable with `sudo chmod +x autostart.sh`
2. Execute `sudo crontab -e`
3. Add at the end of the file the line `@reboot /path/to/autostart.sh` changing '/path/to/autostart.sh' with the actual path to the autoscript

## Disclaimer

This script was written only to be able to quickly set up a test environment for the Log4Shell vulnerability (CVE-2021-44228). **Do not use this script on a production server**

![](./meme.jpg "meme")
