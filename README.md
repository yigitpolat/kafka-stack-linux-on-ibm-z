docker volume create kafka1-conf
docker volume create kafka1-logs
docker volume create kafka2-conf
docker volume create kafka2-logs
docker volume create kafka3-conf
docker volume create kafka3-logs

vi /var/lib/docker/volumes/kafka1-conf/_data/server.properties
[paste this](https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka1-server.properties)

vi /var/lib/docker/volumes/kafka2-conf/_data/server.properties
[paste this](https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka2-server.properties)

vi /var/lib/docker/volumes/kafka3-conf/_data/server.properties
[paste this](https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka3-server.properties)
