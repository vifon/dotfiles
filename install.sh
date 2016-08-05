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


preprocess_configs() {
    local CONF_FILE
    find -name '*.j2' | while IFS=$'\n' read CONF_FILE; do
        ./preprocess.py $CONF_FILE > ${CONF_FILE%.j2}
    done
}

preprocess_configs


if [ $# = 0 ]; then
    PACKAGES=(topdir/*(:t))
else
    PACKAGES=$argv
fi

stow $DRYRUN -v -t $HOME -d topdir --no-folding -S ${=PACKAGES}
