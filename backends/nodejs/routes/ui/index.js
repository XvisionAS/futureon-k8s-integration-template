/**
 * @module server.routes.ext
 * Provides the integration external services.
 */
'use strict'

import express from 'express'
import fieldtwin from "../../src/fieldtwin.js"
import logger from '../../src/logger.js'

const ui = express.Router()

ui.get('/:projectId/:subProjectId/documents', async (req, res) => {
  const { projectId, subProjectId } = req.params
  const jwt = req.headers.authorization

  try {
    const files = await fieldtwin.getDocumentList(jwt, projectId, subProjectId);
    res.send(files);
  } catch (e) {
    logger.error(`Failed to get files: ${e}`);
    res.send([]);
  }
});

export default ui