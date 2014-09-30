# Bacula Director Deamon
FROM centos:centos6
MAINTAINER sym857
ENV VERSION_NUMBER   1

# ENV BACULA_USER     nobody
# ENV BACULA_GRP      nobody
# ENV MYSQL_PASSWORD  S3cr3tSqu1rr3l
# ENV WEBMIN_PASSWORD sym857

# Get ssmtp
#RUN rpm -ivh http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm
#RUN yum update -y
#RUN yum install -y ssmtp

# get postfix
RUN yum install -y postfix

# get bacula
RUN yum install -y bacula-director-mysql bacula-console mysql-server mysql-devel 

# Get Webmin
RUN yum install -y wget
RUN wget http://sourceforge.net/projects/webadmin/files/webmin/1.660/webmin-1.660-1.noarch.rpm
RUN rpm -Uvh webmin-1.660-1.noarch.rpm

# Add Setup Helper scripts 
ADD setup-mysql.sh /setup-mysql.sh
RUN chmod +x /setup-mysql.sh
ADD startbacula.sh /startbacula.sh
RUN chmod +x /startbacula.sh

# Add the wake on lan script
ADD wake-server.sh /wake-server.sh
RUN chmod +x wake-server.sh

VOLUME /data
VOLUME /etc/bacula
VOLUME /var/lib/mysql 
VOLUME /var/spool/bacula

# Setup Mysql Database
#RUN /bin/bash -c /setup-mysql.sh

EXPOSE 9101
#EXPOSE 9102
#EXPOSE 9103
EXPOSE 10000
#EXPOSE 3603
#EXPOSE 25
#EXPOSE 465

CMD ["/bin/bash", "-c",  "/startbacula.sh"]
