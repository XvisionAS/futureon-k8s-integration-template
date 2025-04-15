# syntax=docker/dockerfile:1.2

FROM node:20.9.0-alpine3.18 as base

RUN apk -U --no-cache add openssl bash vim build-base

ENV GLIBC_VERSION 2.35-r1

RUN mkdir /app
WORKDIR /app

## development

FROM base as development

COPY package.json package-lock.json ./
ENV NODE_PATH=/app

RUN --mount=type=secret,id=npmrc,dst=/app/.npmrc \
     npm install --no-audit \
  && npm cache clean --force

COPY . .

CMD npm run development

## production build

FROM base as production

COPY package.json package-lock.json ./
ENV NODE_PATH=/app

RUN --mount=type=secret,id=npmrc,dst=/app/.npmrc \
     npm install --production --no-audit \
  && npm cache clean --force

COPY . .

CMD npm run production