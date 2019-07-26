#!/bin/bash

main()
{
    if ! [[ -f fork.sh ]]
    then
        printf 1>&2 'fatal: execute as ./fork.sh\n'
        exit 1
    fi

    remotes=($(git remote))

    for r in ${remotes[@]}
    do
        git remote remove $r
    done

    printf 'POSTMAN_API_KEY=\n' > .backup-credentials

    rm LICENSE fork.sh
    git add --update
    git commit -m 'Fork Salling-Group/backup-postman'
}

main
