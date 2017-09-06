#!/bin/sh

set -e

SPHINX_MODE=${SPHINX_MODE:-}

if [[ ${SPHINX_MODE} == indexing ]]; then
 indexer --config ${SPHINX_CONF} --all --rotate
 #indexer --config ${SPHINX_CONF} --merge test1 delta --rotate
else
  # allow arguments to be passed to Sphinx search
  if [[ ${1:0:1} = '-' ]]; then
    EXTRA_OPTS="$@"
    set --
  fi

  # default behaviour is to launch Sphinx search
  if [[ -z ${1} ]]; then
    echo "Starting Sphinx search demon..."
    exec $(which searchd) --config ${SPHINX_CONF} --nodetach ${EXTRA_OPTS}
  else
    exec "$@"
  fi
fi

