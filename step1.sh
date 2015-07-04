#!/bin/bash
yum install epel-release -y
yum update -y
yum upgrade -y
yum install firewalld -y
exit 0