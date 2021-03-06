FROM ubuntu:trusty

MAINTAINER Santiago Gomez Saez https://github.com/sgomezsaez, inspired by https://github.com/jojow/winery-dockerfile

ENV MAVEN_VERSION 3.2.5
ENV MAVEN_URL http://artfiles.org/apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz

ENV TOMCAT_VERSION 7.0.54
ENV TOMCAT_URL http://archive.apache.org/dist/tomcat/tomcat-7/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
ENV CATALINA_HOME /opt/tomcat

ENV DEBIAN_FRONTEND noninteractive
ENV PATH ${PATH}:/opt/apache-maven-${MAVEN_VERSION}/bin/:${CATALINA_HOME}/bin

# Add PPA repository to get latest version of node.js
RUN apt-get install -y software-properties-common wget 
RUN add-apt-repository ppa:chris-lea/node.js

# Install and configure dependencies
RUN apt-get update && apt-get install -y git nodejs openjdk-7-jdk && apt-get clean
RUN wget ${MAVEN_URL} && \
        tar -zxf apache-maven-${MAVEN_VERSION}-bin.tar.gz && \
        cp -R apache-maven-${MAVEN_VERSION} /opt
RUN npm install -g bower

# Install tomcat (inspired by jolokia/tomcat-7.0)
RUN wget ${TOMCAT_URL} -O /tmp/catalina.tar.gz && \
        tar -zxf /tmp/catalina.tar.gz -C /opt && \
        ln -s /opt/apache-tomcat-${TOMCAT_VERSION} ${CATALINA_HOME} && \
        rm /tmp/catalina.tar.gz

# Replace 'random' with 'urandom' for quicker startups
RUN rm /dev/random && ln -s /dev/urandom /dev/random

# Sharing Tomcat webapps folder with host
VOLUME ["$TOMCAT_WEBAPPS_PERFINERY", "${CATALINA_HOME}/webapps"]

# Creating and sharing perfinery repo dir
RUN mkdir /opt/perfinery_repo
VOLUME ["$PERFINERY_REPO_DIR", "/opt/perfinery_repo"]

EXPOSE 8080

CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]
