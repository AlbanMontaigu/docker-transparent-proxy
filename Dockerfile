# ==================================================================================================
#
# DOCKER transparent proxy
#
# A transparent proxy for your docker containers with dynamic proxy switch depending your urls / ip
#
# ==================================================================================================

# Base image, small node image on the top of alpine
FROM centos:7

# Current directory configuration
WORKDIR /app

# Transparent proxy volume data
VOLUME /var/run/transparent-proxy

# ADD local files to application folder
ADD ./app /app

# For node native dependencies, need extra tools
RUN curl --silent --location https://rpm.nodesource.com/setup_4.x | bash - \
  && yum install -y git gcc-c++ make nodejs \
  && npm install --production \
  && yum remove -y git gcc-c++ make \
  && yum clean all \
  && rm -fr ~/.npm \
  && rm -fr /tmp/*

# Entrypoint and default command configuration
ENTRYPOINT ["/app/cluster.js"]
CMD ["http://wpad/wpad.dat"]
EXPOSE 3128 12345
