FROM node:16-alpine3.14 as base

WORKDIR /app
COPY package*.json ./
RUN npm install --no-audit && npm cache clean --force
COPY . .

FROM base as development
CMD npm run serve

FROM base as production
RUN apk -U --no-cache add bash nginx
COPY support/nginx.conf /etc/nginx/http.d/default.conf
#COPY support/apply-env-vars.sh /

# This build ensures that the Vue app compiles before the image can be deployed
RUN npm run build

EXPOSE 80

# This rebuild bakes in the VUE_APP env vars that are present in production
CMD /bin/bash -c "npm run build && exec nginx -g 'daemon off;'"
