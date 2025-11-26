#!/bin/bash

function gprocess(){
    ps aux | grep -i "$1" | grep -v grep
}
