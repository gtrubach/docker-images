FROM node:alpine
LABEL Name=scanservjs Version=0.0.1

ARG APP_VERSION=2.9.2

ENV SANED_NET_HOSTS="" \
    SCANIMAGE_LIST_IGNORE="" \
    DEVICES="" \
    OCR_LANG=""

RUN apk add --no-cache \
    imagemagick \
    sane-backend-net \
    sane-utils \
    tesseract-ocr \
    curl

# Temp workaround until https://gitlab.alpinelinux.org/alpine/aports/-/issues/12117 is fixed
RUN apk add --no-cache dbus avahi

WORKDIR /usr/src/app

RUN curl -s https://api.github.com/repos/sbs20/scanservjs/releases/tags/v${APP_VERSION} \
    | grep browser_download_url \
    | cut -d '"' -f 4 \
    | xargs curl -L \
    | tar -zxf - -C /usr/src/app

RUN npm install --only=production

# Patching base path
RUN sed -i 's|href="/|href="|g' client/index.html && \
    sed -i 's|src="/|src="|g' client/index.html

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]
RUN dos2unix /entrypoint.sh

RUN addgroup -g 2001 -S scanservjs && \
    adduser -u 2001 -S scanservjs -G scanservjs
RUN chown -R scanservjs:scanservjs config data /etc/sane.d/net.conf

# Have to use root until https://gitlab.alpinelinux.org/alpine/aports/-/issues/12117 is fixed
#USER scanservjs

ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 8080
