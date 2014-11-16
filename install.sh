#!/bin/zsh

while getopts "ns" ARG; do
    case "$ARG" in
        n)
            DRYRUN="-n"
            ;;
        s)
            git submodule update --init
            ;;
        ?)
            ;;
    esac
done
shift $[$OPTIND-1]

if [ $# = 0 ]; then
    PACKAGES=(topdir/*(:t))
else
    PACKAGES=$argv
fi

stow $DRYRUN -v -t $HOME -d topdir ${=PACKAGES}
