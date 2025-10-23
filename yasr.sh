#!/bin/zsh

scrot --select - | tesseract stdin stdout 2>/dev/null | espeak
