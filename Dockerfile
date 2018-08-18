FROM centos:7
ARG nginx_ver=nginx-1.14.0

RUN yum -y install wget git gcc pcre-devel openssl openssl-devel && \
    cd ~/ && git clone https://github.com/arut/nginx-rtmp-module.git && \
    wget http://nginx.org/download/${nginx_ver}.tar.gz && \
    tar zxf ${nginx_ver}.tar.gz && \
    cd ${nginx_ver} && \
    ./configure --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --prefix=/usr/local/nginx \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --add-module=../nginx-rtmp-module && \
    make -j4 && make install && \
    groupadd nginx && useradd -g nginx nginx && usermod -s /bin/false nginx && \
    rm -rf ~/${nginx_ver} && rm -rf ~/nginx-rtmp-module && rm -f ~/${nginx_ver}.tar.gz
ADD asset/nginx.conf /etc/nginx/nginx.conf
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]