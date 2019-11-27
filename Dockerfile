FROM consol/ubuntu-xfce-vnc

USER root

RUN apt-get update && apt-get install -y supervisor

ENV JAVA_VERSION 8
ENV JAVA_HOME /usr/lib/jvm/jdk1.8.0_211
ENV JRE_HOME /usr/lib/jvm/jdk1.8.0_211/jre/

RUN mkdir -p /usr/lib/jvm
RUN mkdir -p /usr/local/e2e
RUN mkdir -p /usr/local/test
RUN mkdir -p /usr/local/commandConverter

ADD ./jdk1.8.0_211.tar.gz /usr/lib/jvm/

RUN ln -s "$JAVA_HOME/bin/"* "/usr/bin/"

RUN echo "export JAVA_HOME=/usr/lib/jvm/jdk1.8.0_211" >> ~/.bashrc 

ADD ./e2e.tar.gz /usr/local/
COPY ./test.jar /usr/local/test
COPY ./paramConverter.jar /usr/local/commandConverter

COPY ./e2e-start.sh /usr/bin/e2e-start.sh
COPY ./test-start.sh /usr/bin/test-start.sh
COPY ./supervisord.conf /usr/bin/supervisord.conf
COPY ./app.properties /usr/local/e2e/app.properties

RUN chmod +x /usr/bin/e2e-start.sh
RUN chmod +x /usr/bin/supervisord.conf
RUN chmod +x /usr/bin/test-start.sh
RUN chmod +x /usr/local/commandConverter

EXPOSE 5901
EXPOSE 6901


ENTRYPOINT ["java", "-jar", "/usr/local/commandConverter/paramConverter.jar"]

CMD ["-c", "/usr/local/e2e/app.properties"]