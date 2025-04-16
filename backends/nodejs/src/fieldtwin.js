import axios from 'axios'
import logger from './logger.js'

/**
 * Get List of documents
 * @param {string} jwt - Authorization token
 * @param {string} projectId - ID of the project
 * @param {string} subProjectId - ID of the sub-project
 * @returns {Promise<Object>} List of documents or error object
 * @throws {Error} When API call fails
 */
const getDocumentList = async (jwt, projectId, subProjectId) => {
  try {
    const response = await axios.get(
      `${process.env.FIELDAP_API_BASE_URL}/API/v1.10/${projectId}/subProject/${subProjectId}/documents`,
      { 
        headers: {
          'Authorization': jwt,
        }
      }
    );
    return response.data;
  } catch (error) {
    logger.error('Error fetching document list', {
      error: error.message,
      status: error.response?.status,
      data: error.response?.data,
      projectId,
      subProjectId
    });
    throw error; // Re-throwing the error for the caller to handle
  }
}

export default {
  getDocumentList
}