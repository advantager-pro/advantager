FROM sameersbn/ubuntu:14.04.20160308
MAINTAINER sameer@damagehead.com

ENV REDMINE_VERSION=3.2.0 \
    REDMINE_USER="redmine" \
    REDMINE_HOME="/home/redmine" \
    REDMINE_LOG_DIR="/var/log/redmine" \
    REDMINE_CACHE_DIR="/etc/docker-redmine"

ENV RAILS_ENV="production" \
    DB_TYPE="postgresql"

ENV REDMINE_INSTALL_DIR="${REDMINE_HOME}/redmine" \
    REDMINE_DATA_DIR="${REDMINE_HOME}/data" \
    REDMINE_BUILD_DIR="${REDMINE_CACHE_DIR}/build" \
    REDMINE_RUNTIME_DIR="${REDMINE_CACHE_DIR}/runtime"

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv E1DD270288B4E6030699E45FA1715D88E1DF1F24 \
 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv 80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6 \
 && echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv 8B3981E7A6852F782CC4951600A6F0A3C300EE8C \
 && echo "deb http://ppa.launchpad.net/nginx/stable/ubuntu trusty main" >> /etc/apt/sources.list \
 && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ trusty-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor logrotate nginx mysql-client postgresql-client \
      imagemagick subversion git cvs bzr mercurial darcs rsync ruby2.3 locales openssh-client \
      gcc g++ make patch pkg-config gettext-base ruby2.3-dev libc6-dev zlib1g-dev libxml2-dev \
      libmysqlclient18 libpq5 libyaml-0-2 libcurl3 libssl1.0.0 \
      libxslt1.1 libffi6 zlib1g gsfonts \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX \
 && gem install --no-document bundler \
 && rm -rf /var/lib/apt/lists/*

COPY assets/build/ ${REDMINE_BUILD_DIR}/

# This will create the /home/redmine folder
RUN bash ${REDMINE_BUILD_DIR}/preinstall.sh

####### Copy this repo code to /home/redmine
# Create dir for sources
# WORKDIR $REDMINE_INSTALL_DIR
# Install Gemfile so its cache doesn't get invalidated by copying the rest of the sources
# COPY Gemfile Gemfile.lock $REDMINE_INSTALL_DIR/
# ENV BUNDLE_PATH=/home/app/bundle \
#	BUNDLE_GEMFILE=$REDMINE_INSTALL_DIR/Gemfile \
#   BUNDLE_JOBS=2
# RUN bundle install
# Copy sources
COPY . $REDMINE_INSTALL_DIR
########

RUN chown redmine:redmine $REDMINE_INSTALL_DIR -R
# Finish the installation
RUN bash ${REDMINE_BUILD_DIR}/install.sh

COPY assets/runtime/ ${REDMINE_RUNTIME_DIR}/
COPY assets/tools/ /usr/bin/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN apt-get update
RUN apt-get install -y vim openssh-server
# Enable SSH
RUN rm -f /etc/service/sshd/down
#RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
COPY authorized_keys /tmp/authorized_keys
RUN mkdir /root/.ssh
RUN cat /tmp/authorized_keys >> /root/.ssh/authorized_keys && rm -f /tmp/authorized_keys

EXPOSE 80/tcp 443/tcp

VOLUME ["${REDMINE_DATA_DIR}", "${REDMINE_LOG_DIR}"]
WORKDIR ${REDMINE_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
