# syntax=docker/dockerfile:1.2

FROM node:20.9.0-alpine3.18 as base

RUN apk -U --no-cache add bash nginx
WORKDIR /app
COPY . .

## development

FROM base as development

RUN --mount=type=secret,id=npmrc,dst=/app/.npmrc \
    npm install --no-audit && \
    npm cache clean --force && \
    rm -rf ~/.cache

CMD npm run dev

## production build

FROM base as production

COPY support/nginx.conf /etc/nginx/http.d/default.conf

RUN --mount=type=secret,id=npmrc,dst=/app/.npmrc \
    npm install --no-audit --production && \
    npm cache clean --force

# This build ensures that the Svelte app compiles before the image can be deployed
RUN npm run build

EXPOSE 80

# This rebuild bakes in the VITE_ env vars that are present in production
CMD /bin/bash -c "npm run preinstall && npm run build && exec nginx -g 'daemon off;'"