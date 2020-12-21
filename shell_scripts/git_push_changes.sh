#!/bin/bash
args=("$@")

cd /config/
git add .
git commit -m "${args[0]}"
git push -u origin master

exit