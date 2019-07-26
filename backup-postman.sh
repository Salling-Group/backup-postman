#!/bin/bash

fatal()
{
    printf 1>&2 'fatal: %s\n' "$*"
    exit 1
}

ls_entity()
{
    local entity_type=$1

    curl \
        --request GET \
        --silent \
        --header "X-Api-Key: $POSTMAN_API_KEY" \
        --header "Cache-Control: no-cache" \
        "https://api.getpostman.com/${entity_type}"
}

backup_entity()
{
    local entity_type=$1
    local entity_id=$2

    local dir="postman/${entity_type}"
    mkdir -p "$dir"

    printf 'backup %s\n' "$entity_type $entity_id"
    curl \
        --request GET \
        --silent \
        --header "X-Api-Key: $POSTMAN_API_KEY" \
        --header "Cache-Control: no-cache" \
        "https://api.getpostman.com/${entity_type}/$entity_id" |
        jq . > "${dir}/${entity_id}.json"
}

backup_entities()
{
    # Download everything at a rate no faster than 1 RPS.
    for et in collections environments
    do
        ls_entity $et |
            jq --raw-output ".${et}[].uid" |
            xargs \
            -I '{}' \
            --max-procs=2 \
            bash -c "backup_entity $et {}"
    done
}

commit_if_changes()
{
    # Stage everything. If we end up with a diff in the staging area that means
    # we have changes to commit.
    git add postman/
    git diff --staged --quiet postman/ ||
        git commit -m "Automated backup on $(date)"
}

main()
{
    local credentials_file=.backup-credentials

    [[ -f $credentials_file ]] || fatal 'missing configuration file' "$credentials_file"

    . $credentials_file

    [[ -n $POSTMAN_API_KEY ]] || fatal 'no POSTMAN_API_KEY in' "$credentials_file"

    # Expose these to xargs' sub-shell
    export POSTMAN_API_KEY
    export -f backup_entity

    backup_entities

    commit_if_changes
}

main
