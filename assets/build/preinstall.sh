#!/bin/bash
set -e

GEM_CACHE_DIR="${REDMINE_BUILD_DIR}/cache"

BUILD_DEPENDENCIES="libcurl4-openssl-dev libssl-dev libmagickcore-dev libmagickwand-dev \
                    libmysqlclient-dev libpq-dev libxslt1-dev libffi-dev libyaml-dev"

## Execute a command as GITLAB_USER
exec_as_redmine() {
  sudo -HEu ${REDMINE_USER} "$@"
}

# install build dependencies
apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y ${BUILD_DEPENDENCIES}

# add ${REDMINE_USER} user
adduser --disabled-login --gecos 'Redmine' ${REDMINE_USER}
passwd -d ${REDMINE_USER}

# set PATH for ${REDMINE_USER} cron jobs
cat > /tmp/cron.${REDMINE_USER} <<EOF
REDMINE_USER=${REDMINE_USER}
REDMINE_INSTALL_DIR=${REDMINE_INSTALL_DIR}
REDMINE_DATA_DIR=${REDMINE_DATA_DIR}
REDMINE_RUNTIME_DIR=${REDMINE_RUNTIME_DIR}
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
EOF
crontab -u ${REDMINE_USER} /tmp/cron.${REDMINE_USER}
rm -rf /tmp/cron.${REDMINE_USER}
