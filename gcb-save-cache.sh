#!/usr/bin/env bash

tree /workspace

if [[ $1 == "--restore" ]]; then
    echo "restore"
    tar -xf /workspace/cache-archive.tgz -C /home/circleci/.cache/
    rm /workspace/cache-archive.tgz
else
    tar -czvf /workspace/cache-archive.tgz /home/circleci/.cache/
fi


