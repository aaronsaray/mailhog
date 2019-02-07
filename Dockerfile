#
# MailHog Dockerfile
# copied from https://raw.githubusercontent.com/mailhog/MailHog/master/Dockerfile https://github.com/mailhog/MailHog/commit/9cf45e0be910ab46d4fae5c6e9aa7a5b2be32952
#

FROM alpine:3.4

# Install ca-certificates, required for the "release message" feature:
RUN apk --no-cache add \
    ca-certificates

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies \
    go \
    git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go get github.com/mailhog/MailHog \
  && mv /root/gocode/bin/MailHog /usr/local/bin \
  && rm -rf /root/gocode \
  && apk del --purge build-dependencies

# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

USER mailhog

WORKDIR /home/mailhog

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025