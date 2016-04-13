FROM cloudfoundry/trusty64
MAINTAINER Kyle Krull <kyle.krull@here.com>

RUN apt-get -y update \
  && apt-get install -y nginx

RUN echo "daemon off;" >> /etc/nginx/nginx.conf 
RUN mkdir /etc/nginx/ssl

EXPOSE 80

CMD ["nginx"] 

