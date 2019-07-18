FROM ubuntu:latest 
MAINTAINER mohandass
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y install net-tools
RUN ifconfig
#####RUN mvn package -X

#Note that ADD uncompresses this tarball automatically jdk-8u211-linux-x64
ADD jdk-8u211-linux-x64.tar.gz /opt
WORKDIR /opt/jdk1.8.0_211
RUN update-alternatives --install /usr/bin/java java /opt/jdk1.8.0_211/bin/java 1
RUN update-alternatives --install /usr/bin/jar jar /opt/jdk1.8.0_211/bin/jar 1
RUN update-alternatives --install /usr/bin/javac javac /opt/jdk1.8.0_211/bin/javac 1
RUN echo "JAVA_HOME=/opt/jdk1.8.0_211" >> /etc/environment
 
######## TOMCAT apache-tomcat-7.0.78
 
#Note that ADD uncompresses this tarball automatically
ADD apache-tomcat-7.0.78.tar.gz /opt
WORKDIR /opt/
RUN mv  apache-tomcat-7.0.78 tomcat7
RUN echo "JAVA_HOME=/opt/jdk1.8.0_211" >> /etc/default/tomcat7
RUN groupadd tomcat
ADD tomcat-users.xml /opt/tomcat7/conf/
RUN sed -i 's/52428800/5242880000/g' /opt/tomcat7/webapps/manager/WEB-INF/web.xml
RUN useradd -s /bin/bash -g tomcat tomcat
RUN chown -Rf tomcat.tomcat /opt/tomcat7
EXPOSE 8080
RUN sh /opt/tomcat7/bin/startup.sh

#War deployement 
#WORKDIR /target
#COPY /target/main.war /opt/tomcat7/webapps/
#COPY --from=main /target/main.war /opt/tomcat7/webapps/ROOT
