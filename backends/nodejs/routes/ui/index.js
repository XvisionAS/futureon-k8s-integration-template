/**
 * @module server.routes.ext
 * Provides the integration external services.
 */
'use strict'

import express from 'express'
import fieldtwin from '../../src/fieldtwin.js'
import logger from '../../src/logger.js'

const ui = express.Router()

ui.get('/:projectId/:subProjectId/documents', async (req, res) => {
  const { projectId, subProjectId } = req.params
  const jwt = req.headers.authorization

  // Validate inputs
  if (!projectId || !subProjectId) {
    return res.status(400).json({
      error: 'Missing required parameters',
      details: 'Both projectId and subProjectId are required',
    })
  }

  if (!jwt) {
    return res.status(401).json({
      error: 'Unauthorized',
      details: 'Authorization header is required',
    })
  }

  try {
    const files = await fieldtwin.getDocumentList(jwt, projectId, subProjectId)
    res.send(files)
  } catch (e) {
    logger.error(
      `Failed to get files for project ${projectId}, subProject ${subProjectId}: ${e.message}`
    )

    // Determine appropriate status code based on error
    const statusCode = e.response?.status || 500

    res.status(statusCode).json({
      error: 'Failed to retrieve documents',
      details: e.message,
    })
  }
})

export default ui
