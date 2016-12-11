fek-docker-example
==================

Fluentd + Elasticsearch + Kibana

and send local journald logs.

1. Install requires.

  ```
  $ sudo dnf install docker docker-compose
  ```

2. Build Docker Images.

  ```
  $ pushd base-c7-systemd
  $ docker build --rm -t local/c7-systemd .
  $ popd
  $ docker-compose build
  $ docker-compose up -d
  ```

3. Set up systemd.

  ```
  $ sudo cp misc/fek-container.service /etc/systemd/system/
  $ sudo cp misc/journald-fluentd.service /etc/systemd/system/
  $ sudo sed -ie 's!@@CWD@@!'`pwd`'!g' /etc/systemd/system/fek-container.service
  $ sudo systemctl daemon-reload
  $ sudo systemctl enable fek-container.service
  $ sudo systemctl enable journald-fluentd.service
  $ sudo systemctl start journald-fluentd.service
  ```
