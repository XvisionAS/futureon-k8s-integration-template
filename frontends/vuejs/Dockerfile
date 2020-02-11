FROM node:lts-alpine as base
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

FROM base as development
CMD npm run serve

FROM base as production
RUN apk -U --no-cache add bash nginx
RUN mkdir /run/nginx
COPY support/nginx.conf /etc/nginx/conf.d/default.conf
#COPY support/apply-env-vars.sh /

EXPOSE 80
CMD /bin/bash -c "npm run build && exec nginx -g 'daemon off;'"
