FROM local/c7-systemd
MAINTAINER "Tomohiro NAKAMURA" <quickness.net@gmail.com>

RUN yum update -y \
	&& yum clean all

### JRE

RUN pushd /root \
	&& curl -OL \
		-b "oraclelicense=accept-securebackup-cookie" \
		"http://download.oracle.com/otn-pub/java/jdk/8u112-b15/server-jre-8u112-linux-x64.tar.gz" \
	&& tar xf server-jre-8u112-linux-x64.tar.gz \
	&& mkdir -p /usr/java \
	&& mv jdk1.8.0_112 /usr/java/ \
	&& alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_112/bin/java 1 \
	&& rm server-jre-8u112-linux-x64.tar.gz \
	&& popd

### Elasticsearch ###

RUN yum localinstall -y \
		https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.1.1.rpm \
	&& systemctl enable elasticsearch.service \
	&& yum clean all

### kibana ###

RUN yum localinstall -y \
		https://artifacts.elastic.co/downloads/kibana/kibana-5.1.1-x86_64.rpm \
	&& systemctl enable kibana.service \
	&& yum clean all

### envs

COPY es-config /etc/elasticsearch
VOLUME /var/lib/elasticsearch
EXPOSE 9200 9300

COPY kibana/kibana.yml /etc/kibana/kibana.yml
EXPOSE 5601

CMD ["/usr/sbin/init"]

# vim:noet:
