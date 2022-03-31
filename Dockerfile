# Defining build arguments with defaults
# default node version set to 14.19.1 to avoid incompabilites of newer and odler node versions with testes strapi versions
# Default strapi version set to 4.0.0, as it is the minimum version which was tested successfully
ARG     NODE_VERSION=14.19.1 \
        STRAPI_VERSION=4.1.6

# Base image for the container, node needed for the application
# alpine node version is used in order to decrease size and potential security threats
FROM node:${NODE_VERSION}-alpine as production

# Set Container Labels
LABEL   org.opencontainers.image.version=${STRAPI_VERSION}-alpine \
        org.opencontainers.image.url=https://hub.docker.com/r/heg0dmsk/strapi \
        org.opencontainers.image.source=https://github.com/Heg0Dmsk/strapi-docker

# Specify and create working directory for Strapi
# - will contain the entire application including configuration and media assets
WORKDIR /srv/app

# Install required alpine packages
# tini: needed to handle kernel signals properly (PD1) and prevent zombie proccesses
# tzdata: needed to set the time zone for the container
# other packages: needed for strapi
RUN apk --update add --no-cache tini \
                        tzdata \
                        build-base \
                        gcc \
                        autoconf \
                        automake \
                        zlib-dev \
                        libpng-dev \
                        nasm bash \
    # Add the specified version of strapi and required database packages
    && yarn global add @strapi/strapi@${STRAPI_VERSION} --network-timeout 100000 

# Copy entrypoint script into the container and change Ownership to non-root UID and GID 1001
COPY --chown=10001:10001 docker-entrypoint.sh /usr/local/bin/

# Change Ownership to non-root UID and GID 1001
RUN chown 10001:10001 -R /srv/app \
# Add allow executions inside the working dirctory and for the entrypoint script
    && chmod ug+rwx -R /usr/local/bin/docker-entrypoint.sh /srv/app

# Specifies previously installed tini package as the primary entrypoint
# and the entrypoint script as parameter so that tini calls it as a "secondary entrypoint"
ENTRYPOINT ["/sbin/tini", "--", "docker-entrypoint.sh"]

# Specifies which port Strapi exposes
EXPOSE 1337
