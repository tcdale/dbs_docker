FROM sath89/oracle-12c
#
# ENV varibles
#
ENV TERM xterm
#
# Extra packages needed
#
RUN \
  apt-get update;apt-get -qq --assume-yes install \
  binutils \
  curl \
  gcc \
  libswitch-perl \
  libxml-libxml-perl \
  make \
  psmisc \
  rlwrap \
  rsync \
  ssh \
  telnet \
  unzip \
  vim \
  ; \
#
# Symlink needed for oracle patching on ubuntu
#
  ln -s /usr/lib/x86_64-linux-gnu /usr/lib64; \
#
# Directory ready for copying patches tp
#
  mkdir /home/oracle/patches; \
#
# Sanpper scripts
#
  su - oracle; \
  cd /home/oracle; \
  /usr/bin/curl https://codeload.github.com/Fivium/ASBO/zip/master > /home/oracle/avo.zip; \
  /usr/bin/unzip /home/oracle/avo.zip; \
  mv /home/oracle/ASBO-master/osse /home/oracle/; \
  rm -rf /home/oracle/ASBO-master; \
#
# Backup and sync scripts
#
  /usr/bin/curl https://codeload.github.com/Fivium/Oracle-Backup-and-Sync/zip/master > /home/oracle/scripts.zip; \
  /usr/bin/unzip /home/oracle/scripts.zip; \
  mv /home/oracle/Oracle-Backup-and-Sync-master/dbsync /home/oracle/; \
  mkdir /home/oracle/dbsync/logs; \
  mkdir /home/oracle/dbsync/rman_cmd_files; \
  chmod 700 /home/oracle/dbsync/scripts/*.sh; \
#
# Login profiles
#
  mv /home/oracle/Oracle-Backup-and-Sync-master/profiles /home/oracle/; \
  mv /home/oracle/profiles/dot_bash_profile /home/oracle/.bash_profile; \
  cd /home/oracle/profiles; \
  chmod 700 aliases_base.sh create_db_aliases.pl db_profile profile_confirm sql; \
#
# Helper
#
  ln -s /u01/app/oracle/diag/rdbms/xe/xe/trace/alert_xe.log /home/oracle/alert_xe.log; \
#
# Setup backups
#
  mkdir /home/oracle/backups; \
  mkdir /home/oracle/backups/logs; \
  mkdir /home/oracle/backups/files; \
  mkdir /home/oracle/backups/files/zips; \
  mv /home/oracle/Oracle-Backup-and-Sync-master/backup_scripts /home/oracle/backups/scripts; \
  mkdir /home/oracle/backups/scripts/rman; \
  chmod 700 /home/oracle/backups/scripts/*.sh /home/oracle/backups/scripts/*.pl; \
#
# Make sure all oracle files owned by oracle
#
  chown -R oracle. /home/oracle/*; \
#
# Restart sshd
#
  service ssh restart
