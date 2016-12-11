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

### fluentd

COPY misc/td.repo /etc/yum.repos.d/td.repo
RUN rpm --import https://packages.treasuredata.com/GPG-KEY-td-agent \
	&& yes | yum install -y td-agent \
	&& systemctl enable td-agent.service \
	&& yum clean all

RUN yes | yum install -y gcc-c++ libcurl-devel \
	&& sh -c 'echo "gem: --no-document" >> /opt/td-agent/.gemrc' \
	&& HOME=/opt/td-agent td-agent-gem install fluent-plugin-elasticsearch \
	&& yum clean all \
	&& rm -rf /tmp/* /var/tmp/* /opt/td-agent/embedded/lib/ruby/gems/*/cache/*.gem

### envs

RUN sed -ie \
		's/^#\(discovery.zen.minimum_master_nodes: 1\)$/\1/g' \
		/etc/elasticsearch/elasticsearch.yml
VOLUME /var/lib/elasticsearch
EXPOSE 9200 9300

RUN sed -ie 's/#\(server.host:\) "localhost"/\1 "0.0.0.0"/g' \
		/etc/kibana/kibana.yml
EXPOSE 5601

COPY misc/td-agent.conf /etc/td-agent/td-agent.conf
EXPOSE 24225

CMD ["/usr/sbin/init"]

# vim:noet:
