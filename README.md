# Taiga (Project Management Tool) Self-Hosted

[Taiga](https://www.taiga.io) is an open source, self-hosted project management tool.

This repo provides a wizard to install and configure Taiga on Ubuntu with cloudflare acme certificates using Cloudflare DNS API Token

1. Clone this repo

```
> git clone https://user:pass@github.com/Evynly/taiga.git backend
> cd backend
```
2. Run `wizard` script
```
> sudo bash scripts/wizard.sh
```

It will prompt for your root domain name, your taiga domain name, and your Cloudflare api token.  
It will generate random passwords as necessary (a .env file is generated that is used by additional scripts).  
It will install docker, setup everything (including certs, traefik, PostgreSQL, etc.) and will run docker.

3. Create super user

```
> sudo bash scripts/manage.py createsuperuser
```
This is based on [kanzitelli's awesome starter for taiga](https://github.com/starters-dev/taiga) which is based on the original [Taiga docker repo](https://github.com/kaleidos-ventures/taiga-docker)
