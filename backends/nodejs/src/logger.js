/**
 * @module server.logger
 * Provides a logging service for the backend
 */
'use strict'

import logging from '@xvisionas/node-logging'

const production = process.env.NODE_ENV === 'production'
const logLevel = process.env.LOGGING_LEVEL || (production ? 'info' : 'debug')

const source = process.env.FIELDAP_API_BASE_URL + ':' + process.env.HOSTNAME

const logger = logging.application.create({
  stdout: {
    enabled: true,
    level: logLevel,
  },
  // Use Sentry to notify us of warnings and errors
  sentry: {
    enabled: !!process.env.SENTRY_DSN,
    level: 'warn',
    source: source == ':' ? 'fieldtwin-integration' : source,
    url: process.env.SENTRY_DSN,
  },
})

export default logger
