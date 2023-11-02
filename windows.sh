#!/bin/bash

if mount | rg -q "/dev/nvme1n1p5 on /media/dkendall/windows"; then
  xfe "/media/dkendall/windows/Users/dkendall/"
else
  lxqt-sudo mount /dev/nvme1n1p5 /media/dkendall/windows
  xfe "/media/dkendall/windows/Users/dkendall/"
fi
