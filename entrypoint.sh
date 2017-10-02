#!/bin/sh

set -e

SPHINX_MODE=${SPHINX_MODE:-}

# get mysql ip
mysql_ip=`ping mysql -c1 | grep PING | awk '{ print $3 }'|sed 's/[():]//g'`
# set ip to config
sed -i "s/sql_host.*/sql_host        = $mysql_ip /g" ${SPHINX_CONF}

crond

indexer --config ${SPHINX_CONF} test1 --rotate >> ${SPHINX_DIR}/var/log/test1.log
#if [[ ${SPHINX_MODE} == indexing ]]; then
# indexer --config ${SPHINX_CONF} --all --rotate >> ${SPHINX_DIR}/var/log/test1.log 2>1&
#elif [[ ${SPHINX_MODE} == merge ]]; then
# indexer --config ${SPHINX_CONF} --merge test1 delta --rotate >> ${SPHINX_DIR}/var/log/test1.log 2>1&
#else
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

#fi


