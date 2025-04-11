<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();

  export let projects = [];
  export let loading = false;
  
  function handleWorkflowClick(projectId) {
    dispatch('nav', { view: 'workflow', projectId });
  }
  
  function handleViewClick(projectId) {
    dispatch('nav', { view: 'objects', projectId });
  }
  
  function handleSchematicsClick(projectId) {
    dispatch('nav', { view: 'schematics', projectId });
  }

  function handleChatbotClick(projectId) {
    dispatch('nav', { view: 'chatbot', projectId });
  }
</script>

<div class="project-list">
  {#if loading}
    <div class="loading">Loading projects...</div>
  {:else if projects.length === 0}
    <div class="empty-list">
      <p>No projects found</p>
    </div>
  {:else}
    <ul>
      {#each projects as project}
        <li class="project-item">
          <div class="project-info">
            <h3>{project.name}</h3>
            <p class="project-description">{project.description || 'No description'}</p>
          </div>
          <div class="project-actions">
            <button 
              class="action-button workflow" 
              title="Workflow"
              on:click={() => handleWorkflowClick(project.id)}
            >
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M3,3H21V5H3V3M3,7H21V9H3V7M3,11H21V13H3V11M3,15H21V17H3V15M3,19H21V21H3V19Z" />
              </svg>
            </button>
            <button 
              class="action-button view" 
              title="View Objects"
              on:click={() => handleViewClick(project.id)}
            >
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12,9A3,3 0 0,0 9,12A3,3 0 0,0 12,15A3,3 0 0,0 15,12A3,3 0 0,0 12,9M12,17A5,5 0 0,1 7,12A5,5 0 0,1 12,7A5,5 0 0,1 17,12A5,5 0 0,1 12,17M12,4.5C7,4.5 2.73,7.61 1,12C2.73,16.39 7,19.5 12,19.5C17,19.5 21.27,16.39 23,12C21.27,7.61 17,4.5 12,4.5Z" />
              </svg>
            </button>
            <button 
              class="action-button schematics" 
              title="Schematics"
              on:click={() => handleSchematicsClick(project.id)}
            >
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M7,2H17A2,2 0 0,1 19,4V20A2,2 0 0,1 17,22H7A2,2 0 0,1 5,20V4A2,2 0 0,1 7,2M7,4V8H17V4H7M7,10V12H9V10H7M11,10V12H13V10H11M15,10V12H17V10H15M7,14V16H9V14H7M11,14V16H13V14H11M15,14V16H17V14H15M7,18V20H9V18H7M11,18V20H13V18H11M15,18V20H17V18H15Z" />
              </svg>
            </button>
            <button 
              class="action-button chatbot" 
              title="AI Assistant"
              on:click={() => handleChatbotClick(project.id)}
            >
              <svg viewBox="0 0 24 24" width="24" height="24">
                <path fill="currentColor" d="M12,2C6.48,2 2,6.48 2,12C2,17.52 6.48,22 12,22C17.52,22 22,17.52 22,12C22,6.48 17.52,2 12,2M12,20C7.59,20 4,16.41 4,12C4,7.59 7.59,4 12,4C16.41,4 20,7.59 20,12C20,16.41 16.41,20 12,20M12,6C9.79,6 8,7.79 8,10C8,12.21 9.79,14 12,14C14.21,14 16,12.21 16,10C16,7.79 14.21,6 12,6M12,12C10.9,12 10,11.1 10,10C10,8.9 10.9,8 12,8C13.1,8 14,8.9 14,10C14,11.1 13.1,12 12,12M18,16.5C18,17.6 17.1,18.5 16,18.5C14.9,18.5 14,17.6 14,16.5C14,15.4 14.9,14.5 16,14.5C17.1,14.5 18,15.4 18,16.5M8,16.5C8,17.6 7.1,18.5 6,18.5C4.9,18.5 4,17.6 4,16.5C4,15.4 4.9,14.5 6,14.5C7.1,14.5 8,15.4 8,16.5Z" />
              </svg>
            </button>
          </div>
        </li>
      {/each}
    </ul>
  {/if}
</div>

<style>
  .project-list {
    width: 100%;
    max-width: 600px;
    margin: 0 auto;
  }
  
  ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }
  
  .project-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    margin-bottom: 12px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .project-info {
    flex: 1;
  }
  
  .project-info h3 {
    margin: 0 0 4px 0;
    font-size: 18px;
    color: var(--text-color);
  }
  
  .project-description {
    margin: 0;
    font-size: 14px;
    color: var(--text-light);
  }
  
  .project-actions {
    display: flex;
    gap: 8px;
  }
  
  .action-button {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: none;
    background-color: rgba(255, 255, 255, 0.05);
    cursor: pointer;
    transition: background-color 0.2s, transform 0.2s;
  }
  
  .action-button:hover {
    background-color: rgba(255, 255, 255, 0.1);
    transform: scale(1.05);
  }
  
  .action-button.workflow {
    color: #2196F3;
  }
  
  .action-button.view {
    color: #4CAF50;
  }
  
  .action-button.schematics {
    color: #FF9800;
  }
  
  .action-button.chatbot {
    color: #9C27B0;
  }
  
  .empty-list, .loading {
    text-align: center;
    padding: 32px;
    color: var(--text-light);
  }
</style> 