FROM ubuntu:18.04
LABEL maintainer si@maxicoffee.com
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /opt
RUN apt-get update -y
RUN apt-get install -y python3 python3-pip python3-dev redis-server  supervisor nginx git tzdata net-tools nano
RUN sed -i 's/bind 127.0.0.1 ::1/bind 127.0.0.1/g' /etc/redis/redis.conf
RUN apt-get install build-essential libpulse-dev libssh-dev libwebp-dev libvncserver-dev software-properties-common curl gcc libavcodec-dev libavutil-dev libcairo2-dev libswscale-dev libpango1.0-dev libfreerdp-dev libssh2-1-dev libossp-uuid-dev jq wget libpng-dev libvorbis-dev libtelnet-dev libssl-dev libjpeg-dev libjpeg-turbo8-dev libkrb5-dev -y
#RUN add-apt-repository ppa:jonathonf/ffmpeg-3 -y
#RUN apt-get install ffmpeg libffmpegthumbnailer-dev -y
RUN apt-get remove gcc g++ -y
RUN add-apt-repository ppa:ubuntu-toolchain-r/test -y
RUN apt-get update -y
RUN apt-get install gcc-snapshot -y
RUN apt-get install gcc-6 g++-6 -y
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-6 60 --slave /usr/bin/g++ g++ /usr/bin/g++-6
WORKDIR /tmp
RUN wget https://archive.apache.org/dist/guacamole/1.0.0/source/guacamole-server-1.0.0.tar.gz
#COPY guacamole-server-1.0.0.tar.gz /tmp
RUN tar -xvpf guacamole-server-1.0.0.tar.gz
WORKDIR /tmp/guacamole-server-1.0.0
RUN ./configure --with-init-dir=/etc/init.d
RUN make && make install
RUN rm -rf /tmp/guacamole-server*
RUN cp -rfv /usr/local/lib/libguac* /usr/lib/
RUN mkdir -p /usr/lib/x86_64-linux-gnu/freerdp/
RUN ln -s /usr/local/lib/freerdp/guacdr-client.so /usr/lib/x86_64-linux-gnu/freerdp/guacdr-client.so
RUN ln -s /usr/local/lib/freerdp/guacsnd-client.so /usr/lib/x86_64-linux-gnu/freerdp/guacsnd-client.so 
RUN mkdir -p /var/log/web
WORKDIR /opt
#RUN git clone https://github.com/maxicoffee/webterminal.git
COPY . /opt/webterminal/
RUN ls -lah
#COPY requirements.txt /opt/webterminal
#COPY manage.py /opt/webterminal
#COPY createsuperuser.py /opt/webterminal
RUN touch /opt/webterminal/__init__.py

WORKDIR /opt/webterminal
RUN mkdir -p /opt/webterminal/media/admin/Download
RUN mkdir -p /opt/webterminal/database
RUN pip3 install -r requirements.txt
RUN python3 manage.py makemigrations
RUN python3 manage.py migrate
RUN python3 createsuperuser.py
ADD nginx.conf /etc/nginx/nginx.conf
ADD supervisord.conf /etc/supervisor/supervisord.conf
ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
#COPY settings.py /opt/webterminal/webterminal
#RUN mkdir /etc/nginx/certificate
#COPY ssl/nginx-certificate.crt /etc/nginx/certificate
#COPY ssl/nginx.key /etc/nginx/certificate
EXPOSE 80 2100
CMD ["/docker-entrypoint.sh", "start"]
