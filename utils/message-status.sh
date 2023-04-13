#!/usr/bin/env bash

source /opt/utils/colors.sh

error() {
    echo "$(tput_red)$(tput_bold)ERROR:$(tput_normal) $1"
}

warning() {
    echo "$(tput_yellow)$(tput_bold)WARNING:$(tput_normal) $1"
}

info() {
    echo "$(tput_blue)$(tput_bold)INFO:$(tput_normal) $1"
}

success() {
    echo "$(tput_green)$(tput_bold)SUCCESS:$(tput_normal) $1"
}
