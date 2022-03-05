# Taiga (Project Management Tool) Self-Hosted

[Taiga](https://www.taiga.io) is an open source, self-hosted project management tool.

This repo provides a wizard to install and configure Taiga on Ubuntu with cloudflare acme certificates using Cloudflare DNS API Token

0. Install git (if you don't already have git installed)
```
> sudo apt-get install git -y
```

1. Clone this repo
```
> git clone https://user:pass@github.com/Evynly/taiga.git backend
> cd backend
```

2. Run `wizard` script
```
> sudo bash scripts/wizard.sh
```
It will prompt for your root domain name (i.e. domain.com), your taiga domain name (i.e. taiga.domain.com), and your Cloudflare api token (40 character string).  

It will generate random passwords as necessary (a .env file is generated that is used by additional scripts).  
```
Note - if you already have a .env file it will be overwritten
If this is the case, you can modify the wizard script to append rather than overwrite by changing > to >> in the first command that writes to the file
Alternatively you can back up your existing .env file before running this script, then copying the values from backup version into the newly generated .env file.
```

It will install docker, setup everything (including certs, traefik, PostgreSQL, etc.) and will run docker.

3. Create super user
```
> sudo bash scripts/manage.sh createsuperuser
```
It will prompt you for a user name, email address, and password (twice for confirmation)

At this point you should have a fully functional Taiga installation.  I've tested it on a couple Ubuntu/Debian distros (DietPi & Bodhi) on Raspberry Pi 4B's (2GB and 8GB) and on Hyper-V virtual machines.  Including the OS installation the whole setup from blank drive to live took about 15-20 minutes.

This is based on [kanzitelli's awesome starter for taiga](https://github.com/starters-dev/taiga) which is based on the original [Taiga docker repo](https://github.com/kaleidos-ventures/taiga-docker)
