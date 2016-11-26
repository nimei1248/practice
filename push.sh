#!/bin/bash
export LANG=zh_CN.UTF8


git add .
git commit -am "update $(date +%Y%m%d_%H%M%S_%w)"
git push
