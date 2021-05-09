FROM node:16-alpine
RUN apk add -q --progress --update --no-cache ca-certificates wget ffmpeg python gnupg curl && \
    LATEST=$(wget -qO- https://api.github.com/repos/rg3/youtube-dl/releases/latest | grep '"tag_name": ' | sed -E 's/.*"([^"]+)".*/\1/') && \
    LATEST=${YOUTUBE_DL_OVERWRITE:-$LATEST} && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl -O /usr/local/bin/youtube-dl && \
    wget -q https://github.com/rg3/youtube-dl/releases/download/$LATEST/youtube-dl.sig -O /tmp/youtube-dl.sig && \
    gpg --keyserver keyserver.ubuntu.com --recv-keys 'ED7F5BF46B3BBED81C87368E2C393E0F18A9236D' && \
    gpg --verify /tmp/youtube-dl.sig /usr/local/bin/youtube-dl && \
    SHA256=$(wget -qO- https://github.com/rg3/youtube-dl/releases/download/$LATEST/SHA2-256SUMS | head -n 1 | cut -d " " -f 1) && \
    [ $(sha256sum /usr/local/bin/youtube-dl | cut -d " " -f 1) = "$SHA256" ] && \
    apk del gnupg wget && \
    rm -rf /var/cache/apk/* /tmp/youtube-dl.sig && \
    chown 1000 /usr/local/bin/youtube-dl && \
    chmod 700 /usr/local/bin/youtube-dl
RUN mkdir /app
ADD package.json package-lock.json /app/
RUN npm install --prefix /app
COPY src /app/src

ENTRYPOINT ["node", "/app/src/index.js"]
