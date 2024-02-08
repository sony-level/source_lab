#------------------Début couche OS-----------------------
FROM debian:stable-slim
#-----------------Fin couche OS-----------------------

#Metadonnés de l'images

LABEL version="1.0" maintainer="level sony"
 
# Variable temporaires 
ARG APT_Flag="-q -y"
ARG DocumentRoot="var/www/html"

#----Debut couche Apache--------
RUN apt-get update -y && \
	apt-get install ${APT_Flag} apache2
#-----Fin couche apache -------

#-------Couche de Mysql ------

RUN  apt-get install ${APT_Flag} mariadb-server

Copy db/articles.sql /

#----Fin couche Mysql -------

#------Couche php ---------

RUN apt-get install ${APT_Flag} \
	php-mysql \
	php && \
	rm -f ${DocumentRoot}/index.html && \ 
	apt-get autoclean -y 

COPY app ${DocumentRoot}
#-----Fin couche PHP ------

Expose 80

WORKDIR ${DocumentRoot} 
	
ENTRYPOINT service mariadb start && mariadb < /articles.sql && apache2ctl -D FOREGROUND
