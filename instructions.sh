## Build Container Images ##

# ZooKeeper
# Edit apt-get install vim
# Edit chmod 755 /docker-entrypoint.sh
# Command out exposed ports
https://github.com/linux-on-ibm-z/dockerfile-examples/tree/master/ApacheZooKeeper

# Kafka
# Edit apt-get install vim net-tools kafkacat
# Command out exposed ports
https://github.com/linux-on-ibm-z/dockerfile-examples/tree/master/ApacheKafka



## Deploy Zookeeper ##

docker volume create zookeeper-1-conf 
docker volume create zookeeper-1-data
docker run -it --name dummy -v zookeeper-1-conf:/conf1 -v zookeeper-1-data:/data1 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf1/
cp -a /data/* /data1/
vi /conf1/zoo.cfg
vi /data1/myid

docker volume create zookeeper-2-conf 
docker volume create zookeeper-2-data
docker run -it --name dummy -v zookeeper-2-conf:/conf2 -v zookeeper-2-data:/data2 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf2/
cp -a /data/* /data2/
vi /conf2/zoo.cfg
vi /data2/myid

docker volume create zookeeper-3-conf 
docker volume create zookeeper-3-data
docker run -it --name dummy -v zookeeper-3-conf:/conf3 -v zookeeper-3-data:/data3 --rm quay.io/yigitpolat/apache-zookeeper:s390x bash
cp -a /conf/* /conf3/
cp -a /data/* /data3/
vi /conf3/zoo.cfg
vi /data3/myid

# HPVS
docker network create ypyp-network
docker run --network ypyp-network --name zookeeper-1 --restart always -p 12181:12181 -p 12888:12888 -p 13888:13888 -v zookeeper-1-conf:/conf:rw -v zookeeper-1-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x
docker run --network ypyp-network --name zookeeper-2 --restart always -p 22181:22181 -p 22888:22888 -p 23888:23888 -v zookeeper-2-conf:/conf:rw -v zookeeper-2-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x
docker run --network ypyp-network --name zookeeper-3 --restart always -p 32181:32181 -p 32888:32888 -p 33888:33888 -v zookeeper-3-conf:/conf:rw -v zookeeper-3-data:/data:rw --restart always -d quay.io/yigitpolat/apache-zookeeper:s390x

# z/CX
# docker run --name zookeeper-1 --restart always -p 2181:2181 -e ZOO_MY_ID=1 -e ZOO_SERVERS="server.1=0.0.0.0:2888:3888 server.2=zookeeper-2:2888:3888 server.3=zookeeper-3:2888:3888" -d quay.io/yigitpolat/zcx-zookeeper-img
# docker run --name zookeeper-2 --restart always -p 2182:2181 -e ZOO_MY_ID=2 -e ZOO_SERVERS="server.1=zookeeper-1:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zookeeper-3:2888:3888" -d quay.io/yigitpolat/zcx-zookeeper-img
# docker run --name zookeeper-3 --restart always -p 2183:2181 -e ZOO_MY_ID=3 -e ZOO_SERVERS="server.1=zookeeper-1:2888:3888 server.2=zookeeper-2:2888:3888 server.3=0.0.0.0:2888:3888" -d quay.io/yigitpolat/zcx-zookeeper-img

docker logs zookeeper-1
docker logs zookeeper-2
docker logs zookeeper-3
docker exec -it zookeeper-1 bash -c "wget -O - http://localhost:8080/commands/stats"
docker exec -it zookeeper-2 bash -c "wget -O - http://localhost:8080/commands/stats"
docker exec -it zookeeper-3 bash -c "wget -O - http://localhost:8080/commands/stats"


## Deploy Kafka ##

docker volume create kafka-1-conf 
docker volume create kafka-1-logs
docker run -it --name dummy -v kafka-1-conf:/home/kafka/config1 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config1/
rm /home/kafka/config1/server.properties
vi /home/kafka/config1/server.properties

docker volume create kafka-2-conf 
docker volume create kafka-2-logs 
docker run -it --name dummy -v kafka-2-conf:/home/kafka/config2 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config2/
rm /home/kafka/config2/server.properties
vi /home/kafka/config2/server.properties


docker volume create kafka-3-conf 
docker volume create kafka-3-logs
docker run -it --name dummy -v kafka-3-conf:/home/kafka/config3 --rm quay.io/yigitpolat/apache-kafka:s390x bash
cp -a /home/kafka/config/* /home/kafka/config3/
rm /home/kafka/config3/server.properties
vi /home/kafka/config3/server.properties

docker run --network ypyp-network --name kafka-1 -p 19092:19092 -v kafka-1-conf:/home/kafka/config -v kafka-1-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x
docker run --network ypyp-network --name kafka-2 -p 29092:29092 -v kafka-2-conf:/home/kafka/config -v kafka-2-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x
docker run --network ypyp-network --name kafka-3 -p 39092:39092 -v kafka-3-conf:/home/kafka/config -v kafka-3-logs:/home/kafka/logs -d quay.io/yigitpolat/apache-kafka:s390x

docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"
docker exec -it kafka-2 bash -c "kafkacat -b kafka-2:29092 -L"
docker exec -it kafka-3 bash -c "kafkacat -b kafka-3:39092 -L"

docker stop kafka-2
docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"

docker start kafka-2
docker exec -it kafka-1 bash -c "kafkacat -b kafka-1:19092 -L"


key1:message1
key2:message2
key3:message3
kafkacat -P -b kafka-2:29092 -t topic1 -K: -l data.txt
kafkacat -C -b kafka-2:29092 -t topic1

kafkacat -b kafka-1:19092 -t ypyp-topic -P
kafkacat -b kafka-1:19092 -t ypyp-topic