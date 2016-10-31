# ==================================================================================================
#
# DOCKER transparent proxy
#
# A transparent proxy for your docker containers with dynamic proxy switch depending your urls / ip
#
# @see https://pkgs.alpinelinux.org
# @see http://wiki.alpinelinux.org/wiki/Alpine_Linux_package_management
# @see https://github.com/buildkite/docker-buildkite-agent/blob/master/alpine/Dockerfile
#
# ==================================================================================================

# Base image
# 3.4 last version as per 2016-10-31
FROM alpine:3.4

# Maintainer
MAINTAINER Alban Montaigu <https://github.com/AlbanMontaigu>

# Current directory configuration
WORKDIR /app

# Transparent proxy volume data
VOLUME /var/run/transparent-proxy

# Nodejs official package from alpine installation
RUN apk add --update git python make nodejs

# ADD local files to application folder
ADD . /app

# Runs npm post install
RUN npm i --production \
  && rm -fr ~/.npm \
  && rm -fr /tmp/*

# Entrypoint and default command configuration
ENTRYPOINT ["/app/cluster.js"]
CMD ["http://wpad/wpad.dat"]
EXPOSE 3128 12345
