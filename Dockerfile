FROM centos:7

# 维护者信息
MAINTAINER jessin

#设置系统编码
RUN yum install kde-l10n-Chinese -y
RUN yum install glibc-common -y
RUN localedef -c -f UTF-8 -i zh_CN zh_CN.utf8
#RUN export LANG=zh_CN.UTF-8
#RUN echo "export LANG=zh_CN.UTF-8" >> /etc/locale.conf
ENV  LANG C.UTF-8

# 安装git（待优化）
RUN yum -y update \
    && yum -y install vim \
    && yum -y install git

# 执行命令：创建目录
RUN mkdir -p /opt/tools/jdk/
RUN mkdir -p /opt/tools/maven/

# 将jdk1.8.0_191添加到镜像centos的/opt/tools/jdk/jdk_1.8/目录下
COPY apache-maven-3.8.6-bin.tar.gz .
COPY jdk-8u351-linux-aarch64.tar.gz .
RUN tar zxvf jdk-8u351-linux-aarch64.tar.gz -C /opt/tools/jdk/
RUN tar zxvf apache-maven-3.8.6-bin.tar.gz -C /opt/tools/maven/

# 添加环境变量
ENV JAVA_HOME /opt/tools/jdk/jdk1.8.0_351
ENV MAVEN_HOME /opt/tools/maven/apache-maven-3.8.6
##############这是一行#############
ENV PATH $PATH:$JAVA_HOME/bin:$MAVEN_HOME/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/root/bin
##############此行结束#############

RUN mkdir ~/.m2
RUN echo '<?xml version="1.0" encoding="UTF-8"?><settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd"><mirrors><mirror><id>alimaven</id><mirrorOf>central</mirrorOf><name>aliyun maven</name><url>http://maven.aliyun.com/nexus/content/repositories/central/</url></mirror></mirrors></settings>' > ~/.m2/settings.xml
CMD /bin/bash
