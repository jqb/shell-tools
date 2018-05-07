#!/bin/bash


function monitor-files () {
    echo "Monitoring: $PWD"
    inotifywait -r -e close_write,moved_to,create -m $PWD |
        while read -r directory events filename; do
            if [[ "$filename" == *_flymake.py ]]; then
                continue
            fi
            if [[ "$filename" == .#*.py || "$filename" == .#*.clj ]]; then
                continue
            fi
            if [[ "$filename" == *.penv* ]]; then
                continue
            fi
            if [[ "$filename" == *-journal ]]; then  # SQLite crap
                continue
            fi
            if [[ "$filename" == *db ]]; then  # SQLite crap
                continue
            fi
            # echo "# ===> $directory$filename"
            if [[ "$filename" == *.py || "$filename" == *.clj ]]; then
                # echo "# ===> $directory$filename"
                $@
                echo "DONE: $(date +%Y-%m-%d__%H:%M:%S)"
            fi
        done
}


# watch -n1 'rsync -c -r --exclude="__pycache__" /media/sf_xubuntu-vm/code_sync /home/xubuntu-vm/projects/_sync/code'


function sync-source () {
    PERIOD=$2
    if [ "$PERIOD" = "" ]; then
       PERIOD=1
    fi

    if [ "$SYNC_DEST" = "" ]; then
       SYNC_DEST="$PWD"
    fi
    export SYNC_DEST;
    # echo "FROM :: $SYNC_SRC\nTO   :: $SYNC_DEST\n";
    watch -n$PERIOD '\
echo "FROM :: $SYNC_SRC\nTO   :: $SYNC_DEST\n"; \
rsync -c -r \
--exclude="__pycache__" \
--exclude="*.pyc" \
--exclude=".git" \
--exclude="_tests.db" \
--exclude="node_modules" \
$SYNC_SRC $SYNC_DEST'
}
