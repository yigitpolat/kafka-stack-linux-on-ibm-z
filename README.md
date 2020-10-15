```
docker stack deploy -c zookeeper-stack.yml zookeeper
```

```
docker volume create kafka-1-conf
docker volume create kafka-1-logs
docker volume create kafka-2-conf
docker volume create kafka-2-logs
docker volume create kafka-3-conf
docker volume create kafka-3-logs
```

```
curl https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka-1-server.properties -o /var/lib/docker/volumes/kafka-1-conf/_data/server.properties
```

```
curl https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka-2-server.properties -o /var/lib/docker/volumes/kafka-2-conf/_data/server.properties
```

```
curl https://raw.githubusercontent.com/yigitpolat/kafka-stack-linux-on-ibm-z/main/conf/kafka-3-server.properties -o /var/lib/docker/volumes/kafka-3-conf/_data/server.properties
```

```
docker stack deploy -c kafka-stack.yml kafka
```


```
docker stack deploy -c zookeeper-kafka-stack.yml zookeeper-kafka
```
