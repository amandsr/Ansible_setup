#!/bin/bash
sudo apt update -y
sudo apt install ansible* -y
sudo mkdir /home/selfupskill
sudo useradd -s /bin/bash selfupskill
sudo usermod -G sudo selfupskill
sudo chown -R selfupskill:selfupskill /home/selfupskill
