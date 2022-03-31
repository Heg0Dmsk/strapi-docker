[![CD Status](https://img.shields.io/github/workflow/status/Heg0Dmsk/strapi-docker/Build%20And%20Push%20Container%20Images?label=Continious%20Deployment&style=for-the-badge)](https://github.com/Heg0Dmsk/strapi-docker)
[![Last Commit](https://img.shields.io/github/last-commit/Heg0Dmsk/strapi-docker?style=for-the-badge&logoColor=white&logo=github)](https://github.com/Heg0Dmsk/strapi-docker)
[![Pull Requests](https://img.shields.io/github/issues-pr/heg0dmsk/strapi-docker?style=for-the-badge)](https://github.com/Heg0Dmsk/strapi-docker)
[![Repo Size](https://img.shields.io/github/repo-size/heg0dmsk/strapi-docker?style=for-the-badge)](https://github.com/Heg0Dmsk/strapi-docker)
[![Image Size](https://img.shields.io/docker/image-size/heg0dmsk/strapi/latest?style=for-the-badge&logoColor=white&logo=docker)](https://hub.docker.com/r/heg0dmsk/strapi)
[![Pulls](https://img.shields.io/docker/pulls/heg0dmsk/strapi.svg?style=for-the-badge)](https://hub.docker.com/r/heg0dmsk/strapi)
[![Version](https://img.shields.io/docker/v/heg0dmsk/strapi?style=for-the-badge)](https://hub.docker.com/r/heg0dmsk/strapi)
[![License](https://img.shields.io/badge/LICENSE-MIT-blue?style=for-the-badge)](https://github.com/Heg0Dmsk/strapi-docker)

# Table of Contents
- [How to Use](#how_to_use)
  - [Plugin Installation](#plugin-installation)
  - [Do not use this image for production](#not-use-for-production)
  - [Docker Compose](#how_to_use_docker_compose)
  - [Updating](#updating)
- [Volume](#volume)
- [Environment Variables](#environment-variables)

This Repository aims to provide docker images for Strapi v4+. To keep image size and to an minimum and to reduce security threats as a base image a node docker image based upon Alpine Linux is used.
This image aims to fit most use cases, therefore it comes with no bundlesd Strapi Project. Instead a Strapi project gets created after the initial startup. 
Furthermore it comes with no preinstalled Plugins, but plugins can be installed by executing the corrosponding command of a plugin inside the shell of the container.

<a name="how_to_use"></a> 
# How to use

Docker images are available from [Docker Hub](https://hub.docker.com/r/heg0dmsk/strapi) and [GitHub Container Registry (GHCR)](https://github.com/users/heg0dmsk/packages/container/package/strapi).


<a name="plugin-installation"></a> 
## Plugin installation

To install Plugins, the install command needs to be copied from the in-app marketplace or the githup page of the plugin and executed inside the container shell.

<a name="not-use-for-production"></a> 
## Do not use this image for production

To offer a general Strapi container image, the application codes needs to be changed and rebuild during the container runtime, e. g. to install plugins. 
Doing this with a non root user is not feasible, therefore this image should NOT be used in production. Instead a specialized container image for production usage
a specialized container image should be created already containg the build application including configuration and plugins.


<a name="how_to_use_docker_compose"></a> 
## Docker Compose (example)

The following  `docker-compose.yml` file acts as an example how the appliaction can be deployed. It uses Postgres as a database. Instead MySQL/MariaDB or SQLite can be used as well:

```yaml
version: '3.7'

services:

  # Strapi - Content Manage System (CMS)
  strapi:
    image: heg0dmsk/strapi:4.0.0-alpine
    container_name: strapi
    environment:
      DATABASE_CLIENT: postgres
      DATABASE_NAME: dbName
      DATABASE_HOST: StrapiPostgresHostname
      DATABASE_PORT: 5432
      DATABASE_USERNAME: dbUsername
      DATABASE_PASSWORD: dbPassword
      NODE_ENV: development
      TZ: Europe/Berlin
    volumes:
      - ./strapi_data:/srv/app
    ports:
      - '1337:1337'
    depends_on:
      - StrapiPostgresHostname
    networks:
      - strapi

  # Postgres Database for Strapi CMS
  StrapiPostgresHostname:
    image: postgres:14-alpine
    container_name: strapi-postgres
    environment:
      POSTGRES_DB: dbName
      POSTGRES_USER: dbUsername
      POSTGRES_PASSWORD: dbPassword
    volumes:
      - ./postgres_data:/var/lib/postgresql/data
    networks:
      - strapi

networks:
  strapi:
```

Then, run the following command from the directory containing your `docker-compose.yml` file:

```bash
docker-compose up -d
```

<a name="updating"></a> 
## Updating

The process to update the container when a new image is available is dependent on how you set it up initially. If you initially used Docker Compose, run the following commands from the directory containing your `docker-compose.yml` file: 

```bash
# Pull latest version of the images specified in the docker-compose.yml file
docker-compose pull 

# Redeploy
docker-compose up -d

# Remove old dangling Images
docker image prune
```

<a name="volume"></a> 
# Volume

All the strapi data is stored in the directory `/srv/app`. Including
- the application code itself
- configuration data like for the database
- media assetes

Therefore it is suggest to create a volume for the directory, to persist this data between container restarts.
This directory can also be used to mount previously existing projects into the container

<a name="environment-variables"></a> 
# Environment Variables

The container image is configured using the following parameters passed at runtime:

