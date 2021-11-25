FROM docker-hub-cache.whnet.ca/library/alpine:latest
COPY . /code/

FROM docker-hub-cache.whnet.ca/library/alpine:latest

RUN apk add --no-cache ca-certificates less ncurses-terminfo-base krb5-libs libgcc libintl libssl1.1 libstdc++ tzdata userspace-rcu zlib icu-libs curl supervisor

RUN mkdir /code && mkdir /etc/nginx/sites-enabled
COPY . /code/
COPY Dockerfiles/supervisord.conf /etc/supervisord.conf

RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache lttng-ust
RUN curl -L https://github.com/PowerShell/PowerShell/releases/download/v7.1.4/powershell-7.1.4-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz
RUN mkdir -p /opt/microsoft/powershell/7
RUN tar zxf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/7
RUN chmod +x /opt/microsoft/powershell/7/pwsh
RUN ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]