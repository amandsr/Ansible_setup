#!/bin/bash
sudo mkdir /home/selfupskill
sudo useradd -s /bin/bash selfupskill
sudo usermod -G sudo selfupskill
sudo chown -R selfupskill:selfupskill /home/selfupskill
useradd client2_user