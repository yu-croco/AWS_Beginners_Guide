#!/bin/bash
sudo yum update -y
echo y | sudo amazon-linux-extras install docker
sudo service docker start
