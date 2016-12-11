ex-fek
======

Fluentd + Elasticsearch + Kibana

and send local journald logs.

```
$ sudo dnf install docker docker-compose
$ docker-compose build
$ docker-compose up -d
$ sudo cp misc/fek-container.service /etc/systemd/system/
$ sudo cp misc/journald-fluentd.service /etc/systemd/system/
$ sudo systemctl daemon-reload
$ sudo systemctl enable fek-container.service
$ sudo systemctl enable journald-fluentd.service
$ sudo systemctl start journald-fluentd.service
```
