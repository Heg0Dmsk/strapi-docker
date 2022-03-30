# Defining build arguments with defaults
# default node version set to 14.19.1 to avoid incompabilites of newer and odler node versions with testes strapi versions
# Default strapi version set to 4.1.5, as it is the minimum version which was tested successfully
ARG NODE_VERSION=14.19.1 \
    STRAPI_VERSION=4.1.6


# Base image for the container, node needed for the application
# alpine node version is used in order to decrease size and potential security threats
FROM node:${NODE_VERSION}-alpine

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
    && yarn global add @strapi/strapi@${STRAPI_VERSION} \
                    pg \
                    knex \
                    strapi-connector-bookshelf

# Copy entrypoint script into the container
COPY docker-entrypoint.sh /usr/local/bin/

# Specifies previously installed tini package as the primary entrypoint
# and the entrypoint script as parameter so that tini calls it as a "secondary entrypoint"
ENTRYPOINT ["/sbin/tini", "--", "docker-entrypoint.sh"]

# Specifies which port Strapi exposes
EXPOSE 1337