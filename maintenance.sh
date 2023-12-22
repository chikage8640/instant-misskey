#!/bin/bash

cd `dirname $0`

# 使い方
usage() {
    cat <<EOS
instant-misskey maintenance script

Usage:
    bash maintenance.sh [options] <pass>

Options:
    -b, --backup <pass> Backup this directory. rclone pass is required. 
    -m, --maintenance   Update other than Misskey.
    -u, --update        Update All.
    -h, --help          Show this help.

EOS
}

# カレントディレクトリの所有者
OWNER=$(ls -ld . | awk '{print $3}')

# 引数を確認して整理
BACKUP=false
BACKUP_PASS=""
MAINTENANCE=false
UPDATE=false
while (( $# > 0 ))
do
    case "$1" in
        -b|--backup|--backup=*)
            if [[ "$1" =~ ^--backup= ]]; then
                    BACKUP_PASS=$(echo "$1" | sed -e 's/^--backup=//')
            elif [[ -z "$2" || "$2" =~ ^-+ ]]; then
                echo "ERROR: Backup requires a rclone pass."
                exit 1
            else
                BACKUP_PASS=$2
                shift
            fi
            BACKUP=true
            ;;
        -m|--maintenance)
            MAINTENANCE=true
            ;;
        -u|--update)
            UPDATE=true
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            if [[ "$1" =~ "m" ]]; then
                MAINTENANCE=true
            fi
            if [[ "$1" =~ "u" ]]; then
                UPDATE=true
            fi
            if [[ "$1" =~ "b" ]]; then
                if [[ -z "$2" ]]; then
                    echo "ERROR: Backup requires a rclone pass."
                    exit 1
                else
                BACKUP=true
                BACKUP_PASS=$2
                shift
                fi
            fi
            ;;
        *|"")
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
    shift
done

if $MAINTENANCE||$UPDATE; then
    docker compose pull
fi
if $UPDATE; then
    su $OWNER -c "git pull"
fi
if $BACKUP; then
    docker compose down
    echo Backup start...
    XZ_OPT=-9 tar -C ../ -Jcf - $(basename $(pwd)) | rclone rcat $BACKUP_PASS/$(date "+%Y_%m_%d_%H_%M_%S").tar.xz
fi
docker compose up -d
