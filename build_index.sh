#!/bin/sh

function main()
{
    indexer --config ${SPHINX_CONF} test1 --rotate >> ${SPHINX_DIR}/var/log/test1.log 2>1&
}

function delta()
{
    indexer --config ${SPHINX_CONF} delta --rotate >> ${SPHINX_DIR}/var/log/delta.log 2>1&
    indexer --config ${SPHINX_CONF} --merge test1 delta --rotate >> ${SPHINX_DIR}/var/log/merge.log 2>1&
}

function Usage()
{
    echo "Usage: $0 main|delta|merge"
    exit -1
}

case $1 in
    "main")
        main;
        ;;
    "delta")
        delta;
        ;;
    *)
        Usage
esac


