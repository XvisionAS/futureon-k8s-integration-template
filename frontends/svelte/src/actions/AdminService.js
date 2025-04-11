import { DataService } from '@xvisionas/fetch-dataservice';

class AdminService extends DataService {
  async postPromptGuardSettings(data) {
    const response = await this.httpPost(
      `${this.backendURL}/admin/promptguardsettings`,
      data
    );
    return response.json();
  }

  async getTools() {
    const response = await this.httpGet(
      `${this.backendURL}/admin/tools`
    );
    return response.json();
  }

  async postTools(data) {
    const response = await this.httpPost(
      `${this.backendURL}/admin/tools`,
      data
    );
    return response.json();
  }

  async postPrompts(data) {
    const response = await this.httpPost(
      `${this.backendURL}/admin/prompts`,
      data
    );
    return response.json();
  }

  async getModel() {
    const response = await this.httpGet(
      `${this.backendURL}/admin/model`
    );
    return response.json();
  }

  async postModel(data) {
    const response = await this.httpPost(
      `${this.backendURL}/admin/model`,
      { ...data }
    );
    return response.json();
  }
}

// This is the exported instance of the data service
export default new AdminService(
  import.meta.env.VITE_APP_BACKEND_URL,
  import.meta.env.VITE_FIELDAP_API_BASE_URL
);