FROM centos:7.6.1810

MAINTAINER Jasonli

ENV COBBLER_VERSION 2.8.4

RUN yum -y install \
	epel-release \
	yum-plugin-ovl && \
	yum -y install \
	debmirror \
	pykickstart \
	curl \
	wget \
	file \
	fence-agents-all \
	p7zip p7zip-plugins \
	python2-django16 && \
	wget -O /etc/yum.repos.d/cobbler28.repo http://download.opensuse.org/repositories/home:/libertas-ict:/cobbler28/CentOS_7/home:libertas-ict:cobbler28.repo && \
	yum -y install cobbler tftp-server dhcp openssl cobbler-web supervisor && \
	yum -y update && \
	yum clean all
# Remove unnecessary systemd services
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
	rm -f /lib/systemd/system/multi-user.target.wants/*;\
	rm -f /etc/systemd/system/*.wants/*;\
	rm -f /lib/systemd/system/local-fs.target.wants/*; \
	rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
	rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
	rm -f /lib/systemd/system/basic.target.wants/*;\
	rm -f /lib/systemd/system/anaconda.target.wants/*;

ADD supervisord.d/conf.ini /etc/supervisord.d/conf.ini
ADD start.sh /start.sh
ADD set-ip /var/www/cobbler/pub/set-ip
ADD menu /usr/local/bin/menu
ADD kickstarts/sample_end-docker.ks /var/lib/cobbler/kickstarts/sample_end-docker.ks
ADD kickstarts/sample_end-docker-graphical-manual.ks /var/lib/cobbler/kickstarts/sample_end-docker-graphical-manual.ks
RUN chmod +x /usr/local/bin/menu
RUN chmod +x /start.sh

CMD ["/start.sh"]
