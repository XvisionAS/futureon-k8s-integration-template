#!/bin/sh
TS_NODE_PROJECT=/home/olivier/Documents/kpd/tsconfig.json
NODE_PATH=/home/olivier/Documents/kpd/packages node --inspect-brk -r ts-node/register  /home/olivier/Documents/kpd/node_modules/.bin/kpd 
