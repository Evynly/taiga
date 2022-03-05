#!/bin/sh
echo "Installing Docker and Docker Compose..."
apt-get update && \
apt-get -y install apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    zip \
    unzip \
    software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release;   echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
apt-get update && \
apt-get -y install docker-ce

# get latest docker compose released tag
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)

# Install docker-compose
sh -c "curl -L https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose"
chmod +x /usr/local/bin/docker-compose
sh -c "curl -L https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose"


read -p "DNS Domain Name:" DNS_DOMAIN
read -p "Taiga Site Domain Name:" SITE_DOMAIN
read -p "Cloudflare API Token: (must have edit permissions on the domain name above)" CF_API_TOKEN


TAIGA_SECRET_KEY=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c64; echo)
DB_PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c24; echo)
MQ_PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c15; echo)
ERLANG_COOKIE=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c48; echo)

echo -e "Generating .env file using randomly generated passwords..."

# Change the following line to echo "# [SYSTEM]" >> .env if you'd prefer to append these to an existing .env file rather than creating or overwriting the file
echo "# [SYSTEM]" > .env
echo "DOMAIN_NAME=${DNS_DOMAIN}" >> .env
echo "CLOUDFLARE_DNS_API_TOKEN=${CF_API_TOKEN}" >> .env
echo "" >> .env
echo "# [TAIGA]" >> .env
echo "TAIGA_SECRET_KEY=${TAIGA_SECRET_KEY}" >> .env
echo "TAIGA_SITES_DOMAIN=${SITE_DOMAIN}" >> .env
echo "TAIGA_SITES_SCHEME=https" >> .env
echo "TAIGA_SUBPATH=" >> .env
echo "" >> .env
echo "# [POSTGRES]" >> .env
echo "DB_NAME=taiga" >> .env
echo "DB_USER=taiga_admin" >> .env
echo "DB_PASS=${DB_PASSWORD}" >> .env
echo "DB_HOST=taiga-db" >> .env
echo "" >> .env
echo "# [RABBITMQ]" >> .env
echo "RABBITMQ_USER=taiga_mq_user" >> .env
echo "RABBITMQ_PASS=${MQ_PASSWORD}" >> .env
echo "RABBITMQ_VHOST=taiga" >> .env
echo "RABBITMQ_ERLANG_COOKIE=${ERLANG_COOKIE}" >> .env

bash scripts/build.sh
