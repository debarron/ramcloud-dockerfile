FROM ubuntu:18.04

RUN apt-get update
RUN apt-get update --fix-missing
RUN apt-get install -y net-tools iputils-ping
RUN apt-get install -y ssh gcc wget vim

# RAMCloud's dependencies
RUN apt-get install -y build-essential \
git-core doxygen libpcre3-dev \
protobuf-compiler libprotobuf-dev \ 
libcrypto++-dev libevent-dev \
libboost-all-dev libgtest-dev \
libzookeeper-mt-dev zookeeper \
libssl-dev 

# RAMCloud's compilation dependencies
RUN git clone https://github.com/PlatformLab/RAMCloud.git /home/RAMCloud
RUN git clone https://github.com/debarron/RAMCloudServices.git /home/rc-services
RUN wget http://mirrors.sonic.net/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz -O /home/zookeeper.tar.gz && \
tar -xvf /home/zookeeper.tar.gz -C /home &&  mv /home/zookeeper-3.4.14 /home/zookeeper && \
rm /home/zookeeper.tar.gz 

# RAMCloud's structure
RUN mv /home/rc-services/sbin /home/RAMCloud
RUN mv /home/rc-services/conf /home/RAMCloud
RUN mv /home/zookeeper /home/RAMCloud
RUN rm -Rf /home/rc-services

RUN mkdir /home/dev
VOLUME /home/dev

# RAMCloud compile
RUN cd /home/RAMCloud && \
git submodule update --init --recursive && \
ln -s ../../hooks/pre-commit .git/hooks/pre-commit && \
make -j12


