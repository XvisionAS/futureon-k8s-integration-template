import axios from 'axios'

/**
 * Get List of documents
 * @param {*} jwt 
 * @param {*} projectId 
 * @param {*} subProjectId 
 * @returns 
 */
const getDocumentList = async (jwt, projectId, subProjectId) => {
  const response = await axios.get(
    `${process.env.FIELDAP_API_BASE_URL}/API/v1.10/${projectId}/subProject/${subProjectId}/documents`,
    { 
      headers: {
        'Authorization': jwt,
      }
    }
  )
  return response.data
}


export default {
  getDocumentList
}