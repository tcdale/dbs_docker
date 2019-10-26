FROM centos:centos7

ENV container docker \
    PHP_VERSION="71"

COPY oracle-instantclient18.3* /var/

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

RUN yum -y --setopt=tsflags=nodocs update && \
    yum -y --setopt=tsflags=nodocs install httpd && \
    yum clean all

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
&& rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

RUN     yum -y update \
        && yum --setopt=tsflags=nodocs -y install \
        gcc \
        gcc-c++ \
        httpd \
        mod_ssl \
        php70w \
        php70w-cli \
        php70w-devel \
        php70w-mysql \
        php70w-pgsql \
        php70w-pdo_pgsql \
        php70w-pdo_dblib \
        php70w-pdo \
        php70w-mbstring \
        php70w-xml \
        php70w-pecl-apcu \
        php70w-pcntl \
        unzip \
        vim \
        mutt \
        && ln -s /usr/bin/php /usr/local/bin/php \
        && mkdir /opt/dbs-snapper \
        && rm -rf /var/cache/yum/* \
        && yum clean all \
        && echo "TraceEnable Off" >> /etc/httpd/conf/httpd.conf

RUN  cd /var/ \
     && yum install -y oracle-instantclient18.3* \
     && echo "#" >> /etc/php.ini \
     && printf "\n" | /usr/bin/pecl install oci8 \
     && echo "extension=oci8.so" >> /etc/php.ini

ENV TZONE="Europe/London"
RUN echo "${TZONE}" > /etc/timezone \
&& ln -sf /usr/share/zoneinfo/${TZONE} /etc/localtime

RUN yum remove -y kernel-headers
RUN rm /var/oracle-instantclient18.3*
USER root

COPY entry-point.sh /root/
COPY test_ora_connect.php /root/

WORKDIR /opt/dbs-snapper
ENTRYPOINT ["/root/entry-point.sh"]
