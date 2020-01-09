FROM node:lts-alpine as base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM base as development
CMD npm run serve

FROM base as build-stage
RUN npm run build

FROM nginx:stable-alpine as production
RUN apk -U --no-cache add bash
COPY support/nginx.conf /etc/nginx/conf.d/default.conf
COPY support/apply-env-vars.sh /

COPY --from=build-stage /app/dist /app

EXPOSE 80
CMD bin/bash -c "/apply-env-vars.sh && exec nginx -g 'daemon off;'"
