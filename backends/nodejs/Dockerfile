FROM node:lts-alpine as base

RUN apk -U --no-cache add openssl vim

RUN mkdir /app
WORKDIR /app

## development

FROM base as development

COPY package.json package-lock.json ./
ENV NODE_PATH=/app

RUN apk -U --no-cache add --virtual build git make gcc git g++ openssh-client python \
  && npm install --no-audit \
  && npm cache clean --force \
  && apk del --purge build

COPY . .

CMD npm run development

## production build

FROM base as production

COPY package.json package-lock.json ./
ENV NODE_PATH=/app

RUN apk -U --no-cache add --virtual build git make gcc git g++ openssh-client python \
  && npm install --production --no-audit \
  && npm cache clean --force \
  && apk del --purge build

COPY . .

CMD npm run production
