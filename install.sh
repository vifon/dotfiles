#!/bin/bash

while getopts "s" ARG; do
    case "$ARG" in
        s)
            git submodule update --init
            ;;
        ?)
            ;;
    esac
done
shift $[$OPTIND-1]

stow -v "$@" -t $HOME -d topdir topdir/*(:t)
