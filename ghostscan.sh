#!/bin/bash

echo -e '\033[1m
  ▄████  ██░ ██  ▒█████    ██████ ▄▄▄█████▓  ██████  ▄████▄   ▄▄▄       ███▄    █ 
 ██▒ ▀█▒▓██░ ██▒▒██▒  ██▒▒██    ▒ ▓  ██▒ ▓▒▒██    ▒ ▒██▀ ▀█  ▒████▄     ██ ▀█   █ 
▒██░▄▄▄░▒██▀▀██░▒██░  ██▒░ ▓██▄   ▒ ▓██░ ▒░░ ▓██▄   ▒▓█    ▄ ▒██  ▀█▄  ▓██  ▀█ ██▒
░▓█  ██▓░▓█ ░██ ▒██   ██░  ▒   ██▒░ ▓██▓ ░   ▒   ██▒▒▓▓▄ ▄██▒░██▄▄▄▄██ ▓██▒  ▐▌██▒
░▒▓███▀▒░▓█▒░██▓░ ████▓▒░▒██████▒▒  ▒██▒ ░ ▒██████▒▒▒ ▓███▀ ░ ▓█   ▓██▒▒██░   ▓██░
 ░▒   ▒  ▒ ░░▒░▒░ ▒░▒░▒░ ▒ ▒▓▒ ▒ ░  ▒ ░░   ▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░ ▒▒   ▓▒█░░ ▒░   ▒ ▒ 
  ░   ░  ▒ ░▒░ ░  ░ ▒ ▒░ ░ ░▒  ░ ░    ░    ░ ░▒  ░ ░  ░  ▒     ▒   ▒▒ ░░ ░░   ░ ▒░
░ ░   ░  ░  ░░ ░░ ░ ░ ▒  ░  ░  ░    ░      ░  ░  ░  ░          ░   ▒      ░   ░ ░ 
      ░  ░  ░  ░    ░ ░        ░                 ░  ░ ░            ░  ░         ░ 
                                                    ░                             \033[m
\033[1;34m-----------------------------------------------------------------------------------
Made by Berg, 2023
https://github.com/Berg777

-----------------------------------------------------------------------------------\033[m\033[1m'

HOST="$1"
shift

START_TIME=$(date +%s.%N)

while getopts "p:" opt; do
    case $opt in
        p)
            if [ "$OPTARG" = "-" ]; then
                PORTS=$(seq 1 65535)
            elif [[ "$OPTARG" == *-* ]]; then
                PORTS=$(seq $(echo "$OPTARG" | awk -F '-' '{print $1}') $(echo "$OPTARG" | awk -F '-' '{print $2}'))
            else
                PORTS=$(echo "$OPTARG" | sed "s/,/ /g")
            fi
            ;;
        \?)
            echo -e "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

if [ -z "$HOST" ] || [ -z "$PORTS" ]; then
    echo "Usage: $0 <host> -p <ports>"
    echo "Examples: $0 127.0.0.1 -p 21,22,80,139,443,445"
    echo "$0 127.0.0.1 -p-"
    exit 1
fi

echo -e "Starting GhostScan for host \033[1;32m$HOST\033[m\033[1m"
for PORT in $PORTS; do
    if nc -vz $HOST $PORT &>/dev/null; then
        echo -e "Port \033[1;32m$PORT/tcp open\033[m\033[1m"
    fi
done

END_TIME=$(date +%s.%N)
ELAPSED_TIME=$(awk "BEGIN {print $END_TIME - $START_TIME}")

printf "GhostScan done in %.2f seconds!" $ELAPSED_TIME
