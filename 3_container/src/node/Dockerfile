# see: https://nodejs.org/ja/docs/guides/nodejs-docker-webapp/
FROM node:18.0.0

ENV APP_ROOT=/usr/src/app

WORKDIR ${APP_ROOT}

COPY package*.json ./

RUN npm install
COPY . ${APP_ROOT}

CMD [ "node", "index.js" ]
