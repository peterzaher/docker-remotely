FROM ubuntu:focal

ARG DEBIAN_FRONTEND=noninteractive

# environment settings
ENV HOME="/config"

RUN \
 apt-get update && \
 apt-get install -y \
  apt-utils \
  wget \
  apt-transport-https \
  unzip \
  acl \
  ffmpeg \
  libc6-dev \
  libgdiplus \
  libssl1.0 \
  libx11-dev \
  libxtst-dev \
  xclip \
  jq \
  curl && \
  #aspnetcore-runtime-2.2 && \
  mkdir -p /var/www/remotely && \
  wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb && \
  dpkg -i packages-microsoft-prod.deb && \
  apt-get update && \
  apt-get install -y dotnet-runtime-3.1 && \
  wget -q https://github.com/lucent-sea/Remotely/releases/download/v2021.01.22.0533/Remotely_Server_Linux-x64.zip && \
  unzip -o Remotely_Server_Linux-x64.zip -d /var/www/remotely && \
  rm Remotely_Server_Linux-x64.zip && \
  setfacl -R -m u:www-data:rwx /var/www/remotely && \
  chown -R www-data:www-data /var/www/remotely

# ports and volumes
EXPOSE 5000

# fix port bindings and set config environment
ENV ASPNETCORE_ENVIRONMENT="Production"
ENV ASPNETCORE_URLS="http://*:80"

WORKDIR /var/www/remotely
CMD ["/usr/bin/dotnet", "Remotely_Server.dll"]
