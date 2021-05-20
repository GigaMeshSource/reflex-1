FROM tomcat:latest
MAINTAINER Assurly  dieumerci.kimpolo@assurly.com
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install vim

RUN mkdir -p /usr/local/tomcat/reflex-config
RUN mkdir -p /usr/local/tomcat/logs
RUN mkdir -p /usr/local/tomcat/webapps/continue
RUN mkdir -p /heap.dump.dir


ENV REFLEX_CONFIG_ROOTDIR /usr/local/tomcat/reflex-config
ENV REFLEX_LOG_ROOTDIR /usr/local/tomcat/logs
ENV CATALINA_OPTS '-Xms512M -Xmx4096M -Dfile.encoding=UTF-8 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/heap.dump.dir'

COPY ./Reflex/Assurly_reflex_0.0.1-2020-11-12/webapps/ras-web.war /usr/local/tomcat/webapps/
COPY ./Reflex/Assurly_reflex_0.0.1-2020-11-12/webapps/cep-core.war /usr/local/tomcat/webapps/
COPY ./cep-ui-custom-1618520751706 /usr/local/tomcat/webapps/continue
COPY ./Reflex/Assurly_reflex_0.0.1-2020-11-12/reflex-config /usr/local/tomcat/reflex-config

VOLUME /usr/local/tomcat/webapps
VOLUME /usr/local/tomcat/webapps/continue
VOLUME /heap.dump.dir

EXPOSE 8080