# ZooKeeper - Kafka Cluster on S390X

This content is based on [IBM z/OS Container Extensions (zCX) Use Cases](http://www.redbooks.ibm.com/Redbooks.nsf/RedbookAbstracts/sg248471.html?Open) book under IBM Redbooks publication.

## Step-by-Step

### Build Container Images

#### Zookeeper

```
docker build -t quay.io/yigitpolat/apache-zookeeper:s390x .
```

or download [Dockerfile](https://github.com/linux-on-ibm-z/dockerfile-examples/tree/master/ApacheZooKeeper) and do things below.

- Edit apt-get install vim
- Edit chmod 755 /docker-entrypoint.sh
- Command out exposed ports

#### Kafka

```
docker build -t quay.io/yigitpolat/apache-kafka:s390x .
```

or download [Dockerfile](https://github.com/linux-on-ibm-z/dockerfile-examples/tree/master/ApacheKafka) and do things below.
- Edit apt-get install vim net-tools kafkacat
- Command out exposed ports

### Deploy Zookeeper

- Change /conf1/zoo.cfg file with zookeeper-1.cfg
- Change /data1/myid file with zookeeper-1-myid

```
docker volume create zookeeper-1-conf
docker volume create zookeeper-1-data
docker run -it --name dummy -v zookeeper-1-conf:/conf1 -v zookeeper-1-data:/data1 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf1/
cp -a /data/* /data1/
rm /conf1/zoo.cfg
vi /conf1/zoo.cfg
rm /data1/myid
vi /data1/myid
exit
```

- Change /conf1/zoo.cfg file with zookeeper-2.cfg
- Change /data1/myid file with zookeeper-2-myid

```
docker volume create zookeeper-2-conf
docker volume create zookeeper-2-data
docker run -it --name dummy -v zookeeper-2-conf:/conf2 -v zookeeper-2-data:/data2 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf2/
cp -a /data/* /data2/
rm /conf2/zoo.cfg
vi /conf2/zoo.cfg
rm /data2/myid
vi /data2/myid
exit
```

- Change /conf1/zoo.cfg file with zookeeper-3.cfg
- Change /data1/myid file with zookeeper-3-myid

```
docker volume create zookeeper-3-conf
docker volume create zookeeper-3-data
docker run -it --name dummy -v zookeeper-3-conf:/conf3 -v zookeeper-3-data:/data3 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf3/
cp -a /data/* /data3/
rm /conf3/zoo.cfg
vi /conf3/zoo.cfg
rm /data3/myid
vi /data3/myid
exit
```

```
docker network create ypyp-network

docker run --network ypyp-network --name zookeeper-1 --restart always -p 12181:12181 -p 12888:12888 -p 13888:13888 -v zookeeper-1-conf:/conf:rw -v zookeeper-1-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x

docker run --network ypyp-network --name zookeeper-2 --restart always -p 22181:22181 -p 22888:22888 -p 23888:23888 -v zookeeper-2-conf:/conf:rw -v zookeeper-2-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x

docker run --network ypyp-network --name zookeeper-3 --restart always -p 32181:32181 -p 32888:32888 -p 33888:33888 -v zookeeper-3-conf:/conf:rw -v zookeeper-3-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x
```

Check if everything works fine

```
docker exec -it zookeeper-1 bash -c "wget -O - http://localhost:8080/commands/stats"
docker exec -it zookeeper-2 bash -c "wget -O - http://localhost:8080/commands/stats"
docker exec -it zookeeper-3 bash -c "wget -O - http://localhost:8080/commands/stats"
```

### Deploy Kafka

- Change /home/kafka/config1/server.properties file with kafka-1-server.properties

```
docker volume create kafka-1-conf
docker volume create kafka-1-logs
docker run -it --name dummy -v kafka-1-conf:/home/kafka/config1 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config1/
rm /home/kafka/config1/server.properties
vi /home/kafka/config1/server.properties
exit
```

- Change /home/kafka/config2/server.properties file with kafka-2-server.properties

```
docker volume create kafka-2-conf
docker volume create kafka-2-logs
docker run -it --name dummy -v kafka-2-conf:/home/kafka/config2 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config2/
rm /home/kafka/config2/server.properties
vi /home/kafka/config2/server.properties
exit
```

- Change /home/kafka/config3/server.properties file with kafka-3-server.properties

```
docker volume create kafka-3-conf
docker volume create kafka-3-logs
docker run -it --name dummy -v kafka-3-conf:/home/kafka/config3 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config3/
rm /home/kafka/config3/server.properties
vi /home/kafka/config3/server.properties
exit
```

```
docker run --network ypyp-network --name kafka-1 -p 19092:19092 -v kafka-1-conf:/home/kafka/config -v kafka-1-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x

docker run --network ypyp-network --name kafka-2 -p 29092:29092 -v kafka-2-conf:/home/kafka/config -v kafka-2-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x

docker run --network ypyp-network --name kafka-3 -p 39092:39092 -v kafka-3-conf:/home/kafka/config -v kafka-3-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x
```

Check if everything works fine with Kafkacat
kafkacat is a command line utility that you can use to test and debug Apache Kafka® deployments. You can use kafkacat to produce, consume, and list topic and partition information for Kafka.


```
docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"
docker exec -it kafka-2 bash -c "kafkacat -b kafka-2:29092 -L"
docker exec -it kafka-3 bash -c "kafkacat -b kafka-3:39092 -L"

docker stop kafka-2
docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"

docker start kafka-2
docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"
```

Consumer Mode
```
kafkacat -b <hostname>:<port> -t <topic-name> -C
kafkacat -b <hostname>:<port> -t <topic-name> -C -K\t
```

Producer Mode
```
kafkacat -b <hostname>:<port> -t <topic-name> -P
```

```
vi /tmp-data/msgs
These are
three messages
sent through kafkacat

kafkacat -b <hostname>:<port> -t <topic-name> -P -T -l /tmp-data/msgs
# Without the -l flag, the entire file is treated as its own message
# The -T flag to also echo the input to stdout
```

```
kafkacat -b <hostname>:<port> -t <topic-name>  -P -K:
1:foo
2:bar
```

Set partition
```
kafkacat -b localhost:9092 -t partitioned_topic -P -p 1
```

## Docker Swarm Deployment

### All together

```
docker stack deploy -c zookeeper-kafka-stack.yml zookeeper-kafka
```


### First Zookeeper then Kafka

```
docker stack deploy -c zookeeper-stack.yml zookeeper
```

```
docker stack deploy -c kafka-stack.yml kafka
```
