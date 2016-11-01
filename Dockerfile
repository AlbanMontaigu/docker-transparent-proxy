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

# Base image, small node image on the top of alpine
FROM mhart/alpine-node:4

# Maintainer
MAINTAINER Alban Montaigu <https://github.com/AlbanMontaigu>

# Current directory configuration
WORKDIR /app

# Transparent proxy volume data
VOLUME /var/run/transparent-proxy

# For node native dependencies, need extra tools
RUN apk add --no-cache make gcc g++ python

# ADD local files to application folder
ADD ./app /app

# App context installation
RUN npm install --production \
  && rm -fr ~/.npm \
  && rm -fr /tmp/*

# Entrypoint and default command configuration
ENTRYPOINT ["/app/cluster.js"]
CMD ["http://wpad/wpad.dat"]
EXPOSE 3128 12345
