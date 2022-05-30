FROM ovaledgellc/ovaledge:tomcat-9.0.40

MAINTAINER info@ovaledge.com

ENV DEFAULT_OVALEDGE_BIGQUERY_MAX_CONNECTIONS=10

RUN apk update && apk add curl && apk add jq
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install --no-cache-dir \
        awscli \
    && rm -rf /var/cache/apk/*

RUN wget https://jenkins-ovaledge-s3.s3.amazonaws.com/jenkins-5.2-s3/3264/ovaledge.war

RUN mkdir /root/temp

RUN cp ovaledge.war /root/temp/
COPY catalina.properties /root/temp/catalina.properties


EXPOSE 8080


COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
