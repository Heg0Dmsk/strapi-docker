#!/bin/sh

set -ea

if [ ! -f "package.json" ]; then

  echo "Using strapi version $(strapi version)"
  echo "No project found at /srv/app. Creating a new strapi project ..."

  strapi new . --no-run \
    --dbclient=${DATABASE_CLIENT:-sqlite} \
    --dbhost=$DATABASE_HOST \
    --dbport=$DATABASE_PORT \
    --dbname=$DATABASE_NAME \
    --dbusername=$DATABASE_USERNAME \
    --dbpassword=$DATABASE_PASSWORD \
    --dbssl=$DATABASE_SSL \
    $EXTRA_ARGS

  echo -e "The Strapi project was successfully created \n"

elif [ ! -d "node_modules" ] || [ ! "$(ls -qAL node_modules 2>/dev/null)" ]; then

  if [ -f "yarn.lock" ]; then
    echo "Verifying that all node modules have been installed using yarn ..."
    yarn install --prod --silent
  else
    echo "Verifying that all node modules have been installed using npm ..."
    npm install --only=prod --silent
  fi

  echo "If not allready the case, all required node modules have been installed"
fi

# Sets the strapi mode to prodcution if the node environment is aswell set to prodcution
# Defautl value for strapi mode = develop (allows for )
if [ "$NODE_ENV" = "production" ]; then
  STRAPI_MODE="start"
else
  STRAPI_MODE="develop"
fi

echo "Starting your app with the strapi mode - ${STRAPI_MODE} ..."
exec strapi $STRAPI_MODE


