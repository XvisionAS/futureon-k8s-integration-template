import { DataService } from '@xvisionas/fetch-dataservice';

class AdminService extends DataService {
  setProject(projectId, subProjectId) {
    this.projectId = projectId;
    const subProjectIdNoEvents = subProjectId.split(':')[0];
    this.subProjectId = subProjectIdNoEvents;
  }

  async getDocuments() {
    const response = await this.httpGet(
      `${this.backendURL}/ui/${this.projectId}/${this.subProjectId}/documents`,
    );
    return response.json();
  }
}

// This is the exported instance of the data service
export default new AdminService(
  import.meta.env.VITE_APP_BACKEND_URL,
  import.meta.env.VITE_FIELDAP_API_BASE_URL
);