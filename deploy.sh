#!/usr/bin/env bash

TAGS=$(git tag)
NOW=$(date +%Y%m%d%H%M)

for TAG in ${TAGS}; do
    echo ${TAG}
    if [[ ${TAG} -le ${NOW} ]]; then
        exit 0
    fi
done

exit 1

