#!/bin/bash


function monitor-files () {
    echo "Monitoring: $PWD"
    inotifywait -r -e close_write,moved_to,create -m $PWD |
        while read -r directory events filename; do
            if [[ "$filename" == *_flymake.py ]]; then
                continue
            fi
            if [[ "$filename" == *.pyc ]]; then
                continue
            fi
            if [[ "$filename" =~ .*_flymake.py ]]; then
                continue
            fi
            if [[ "$filename" == .#* ]]; then
                continue
            fi
            if [[ "$filename" == *-journal ]]; then  # SQLite crap
                continue
            fi
            if [[ "$filename" == *db ]]; then  # SQLite crap
                continue
            fi
            if [[ "$directory" =~ .*.git ]]; then
                continue
            fi
            if [[ "$directory" =~ .*.penv ]]; then
                continue
            fi
            if [[ "$directory" =~ .*__pycache__ ]]; then
                continue
            fi
            if [[ "$directory" =~ .*.htmlcov ]]; then
                continue
            fi
            if [[ "$directory" =~ .*dist ]]; then  # typescript tryouts // should be defineable in directory
                continue
            fi
            if [[ "$directory" =~ .*node_modules ]]; then
                continue
            fi
            # echo "# ===> $directory$filename"
            # if [[ "$filename" == *.py || "$filename" == *.clj ]]; then
            echo "# ==> $directory$filename"
            export FILE_MONITOR_CHANGED_FILEPATH="$directory$filename"
            export FILE_MONITOR_CHANGED_FILENAME="$filename"
            export FILE_MONITOR_CHANGED_FILEPATH_RELATIVE="$(realpath --relative-to "$PWD" "$FILE_MONITOR_CHANGED_FILEPATH")"
            echo "# ================================================="
            time $@
            echo "# ================================================="
            echo "DONE: $(date +%Y-%m-%d__%H:%M:%S)"
            # fi
        done
}


# function sync-cua-with-server () {
#     (cd /home/xubuntu-vm/projects/swisscom_workspace/swisscom/projects && \
#             rsync -r -og --chown=cuadev:cuadev --safe-links --executability \
#                   --exclude "*.pyc" \
#                   --exclude ".penv/" \
#                   --exclude ".git/" \
#                   --exclude "cua-project/tmp/*" \
#                   --exclude "cua-project/.sass-cache" \
#                   --exclude "cua-project/.htmlcov" \
#                   --exclude "__pycache__" \
#                   cua-project cua-client cua-common ibe-tablib django-sortedm2m cuadev@jqbdev01:/home/cuadev/sync
#     )  # end of sub-shell
# }


function sync-ibe-with-server () {
    # --exclude ".git/" \
    (cd /home/xubuntu-vm/projects/swisscom_workspace/ && \
            rsync -r -og --safe-links --executability \
                  --exclude "*.pyc" \
                  --exclude ".penv/" \
                  --exclude "*_flymake.py" \
                  --exclude "*.ibe-platform.ch__regeneration_only.log" \
                  --exclude "*.recent.txt" \
                  --exclude "env" \
                  --exclude "environments_configuration" \
                  --exclude "projects/cua-project/tmp/" \
                  --exclude "projects/cua-project/.sass-cache" \
                  --exclude "projects/cua-project/.htmlcov" \
                  --exclude "projects/blackbox" \
                  --exclude "projects/envs_sync" \
                  --exclude "projects/importanalyser" \
                  --exclude "projects/obfuscator" \
                  --exclude "projects/sync-cuadev" \
                  --exclude "__pycache__" \
                  swisscom/* swisscom/.* root@jqbdev01:/home/dockerapps/ibe \
            && \
            ssh -t root@jqbdev01 'chown -R dockerapps:dockerapps /home/dockerapps/ibe' \
            && \
            echo "DONE"
    )  # end of sub-shell
}


function sync-cua-with-server () {
    # --exclude ".git/" \
    # --exclude "tmp/data/dumps" \
    (cd /home/xubuntu-vm/projects/swisscom_workspace/swisscom/projects && \
            rsync -r -og --safe-links --executability \
                  --exclude "*.pyc" \
                  --exclude ".penv/" \
                  --exclude "*_flymake.py" \
                  --exclude "tmp" \
                  --exclude ".sass-cache" \
                  --exclude ".htmlcov" \
                  --exclude "__pycache__" \
                  cua-project/* cua-project/.* root@jqbdev01:/home/dockerapps/ibe/projects/cua-project \
            && \
            ssh -t root@jqbdev01 'chown -R dockerapps:dockerapps /home/dockerapps/ibe/projects/cua-project' \
            && \
            echo "DONE"
    )  # end of sub-shell
}


function sync-blocks-with-server () {
    (cd /home/xubuntu-vm/projects/ && \
            rsync -r -og --chown=dockerapps:dockerapps --safe-links --executability \
                  --exclude "*.pyc" \
                  --exclude "*_flymake.py" \
                  --exclude ".penv/" \
                  --exclude "__pycache__" \
                  blocks_project/* blocks_project/.* root@jqbdev01:/home/dockerapps/blocksapp \
            && \
            ssh -t root@jqbdev01 'chown -R dockerapps:dockerapps /home/dockerapps/blocksapp' \
            && \
            ssh -t root@jqbdev01 'cp -r /home/dockerapps/blocksapp/static_collected /home/dockerapps/blocksapp_static/static && chown -R dockerapps:www-data /home/dockerapps/blocksapp_static'


    )  # end of sub-shell
}


function sync-static-blocks-with-server () {
    (cd /home/xubuntu-vm/projects/sandbox/Blocks/ && \
            rsync -r -og --chown=dockerapps:www-data --safe-links --executability \
                  --exclude "*.pyc" \
                  --exclude ".penv/" \
                  --exclude "*_flymake.py" \
                  --exclude "__pycache__" \
                  --exclude "node_modules" \
                  index.html dist/* style root@jqbdev01:/home/dockerapps/blocksapp_static \
            && \
            ssh -t root@jqbdev01 'chown -R dockerapps:www-data /home/dockerapps/blocksapp_static'
    )  # end of sub-shell
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
