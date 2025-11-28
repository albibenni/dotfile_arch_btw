#!/bin/bash

git clone --recursive --depth 1 --shallow-submodules https://github.com/akinomyoga/ble.sh.git
cd ble.sh
make install PREFIX=~/.local
