import cors from 'cors';
import compression from 'compression';
import http from 'http';
import express from 'express';
import { Server } from "socket.io";
import { EventEmitter } from 'events';

import logger from './src/logger.js'
import uiRoutes from './routes/ui/index.js'
import logging from '@xvisionas/node-logging'
import middleware from '@xvisionas/express-middleware'

// Increase the maximum number of event listeners
EventEmitter.defaultMaxListeners = 33;

const requireEnvVars = () => {
  const requireVars = ['FIELDAP_API_BASE_URL']
  for (const name of requireVars) {
    if (!process.env[name]) {
      throw new Error(`Env var ${name} is not defined. Cannot start.`)
    }
  }
}
process.env.LANGCHAIN_CALLBACKS_BACKGROUND=true

requireEnvVars()
const app = express();
app.use(express.json({ limit: '100mb' }));
app.use(logging.access({ stdout: { enabled: true, format: 'common' } }))
app.use(compression())
app.use(cors())

// Open routes for Kubernetes liveness and health checks
app.use('/healthz', function (req, res, _next) {
  res.status(200).send('ok')
})
app.use('/ready', function (req, res, _next) {
  res.status(200).json({ ready: true })
})

let server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: true,  // Replace with your frontend's origin
    credentials: true
  }
});
// Middleware to attach io to req object
app.use((req, res, next) => {
  req.io = io;
  next();
});

app.use(
  '/ui',
  middleware.auth.fieldtwin({ apiBaseURL: process.env.FIELDAP_API_BASE_URL, logger }),
  uiRoutes
)

server.listen(process.env.PORT || 3001, () => {
  console.log(`Listening on port ${process.env.PORT || 3001}`);
});