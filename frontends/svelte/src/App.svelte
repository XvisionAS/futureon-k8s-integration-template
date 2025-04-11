<script>
  import { onMount } from 'svelte';
  import ProjectList from './components/ProjectList.svelte';
  import WorkflowView from './components/WorkflowView.svelte';
  import ObjectsView from './components/ObjectsView.svelte';
  import SchematicsView from './components/SchematicsView.svelte';
  import Chatbot from './components/Chatbot.svelte';
  import Login from './components/Login.svelte';

  let loading = true;
  let error = null;
  let currentView = 'login';
  let selectedProjectId = null;
  let selectedProjectName = '';
  let isAuthenticated = false;
  
  // Dummy projects data
  const projects = [
    { id: 1, name: 'North Sea Platform', description: 'Offshore oil production platform in the North Sea' },
    { id: 2, name: 'Gulf of Mexico Pipeline', description: 'Subsea pipeline network in the Gulf of Mexico' },
    { id: 3, name: 'West Africa FPSO', description: 'Floating production storage and offloading vessel off the coast of West Africa' },
    { id: 4, name: 'North Atlantic Wind Farm', description: 'Offshore wind energy project in the North Atlantic' },
    { id: 5, name: 'Arctic Exploration', description: 'Oil exploration project in the Arctic region' }
  ];

  onMount(async () => {
    // In a real app, you would check for existing session/token here
    loading = false;
  });

  function handleNavigation(event) {
    const { view, projectId } = event.detail;
    selectedProjectId = projectId;
    selectedProjectName = projects.find(p => p.id === projectId)?.name || '';
    currentView = view;
  }
  
  function handleBack() {
    currentView = 'projects';
    selectedProjectId = null;
    selectedProjectName = '';
  }

  function handleLoginSuccess() {
    isAuthenticated = true;
    currentView = 'projects';
  }

  function handleLogout() {
    window.location.reload();
  }
</script>

<main class="container">
  {#if isAuthenticated}
    <header>
      <div class="header-content">
        <div class="header-left">
          <h1>FieldTwin Integration</h1>
          {#if currentView === 'projects'}
            <p>Projects</p>
          {:else if currentView === 'chatbot'}
            <p>AI Assistant</p>
          {:else}
            <p>{selectedProjectName}</p>
          {/if}
        </div>
        <button class="logout-button" on:click={handleLogout}>
          Logout
        </button>
      </div>
    </header>

    <div class="content">
      {#if currentView === 'projects'}
        <ProjectList 
          {projects} 
          {loading} 
          on:nav={handleNavigation} 
        />
      {:else if currentView === 'workflow'}
        <WorkflowView 
          projectId={selectedProjectId} 
          projectName={selectedProjectName} 
          on:back={handleBack} 
        />
      {:else if currentView === 'objects'}
        <ObjectsView 
          projectId={selectedProjectId} 
          projectName={selectedProjectName} 
          on:back={handleBack} 
        />
      {:else if currentView === 'schematics'}
        <SchematicsView 
          projectId={selectedProjectId} 
          projectName={selectedProjectName} 
          on:back={handleBack} 
        />
      {:else if currentView === 'chatbot'}
        <Chatbot on:back={handleBack} />
      {/if}
      
      {#if error}
        <div class="error-message">
          {error}
        </div>
      {/if}
    </div>
  {:else}
    <Login on:loginSuccess={handleLoginSuccess} />
  {/if}
</main>

<style>
  .container {
    display: flex;
    flex-direction: column;
    height: 100vh;
    max-width: 100%;
    padding: 0;
    margin: 0;
  }

  header {
    background-color: rgb(50, 53, 56);
    color: white;
    border-bottom: 2px solid var(--border-color);
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }

  .header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem;
  }

  .header-left {
    flex: 1;
  }

  header h1 {
    margin: 0;
    font-size: 1.5rem;
  }

  header p {
    margin: 0.5rem 0 0;
    font-size: 0.9rem;
    opacity: 0.9;
  }

  .logout-button {
    background-color: transparent;
    color: white;
    border: 1px solid white;
    padding: 0.5rem 1rem;
    border-radius: 4px;
    cursor: pointer;
    font-size: 0.9rem;
    transition: all 0.2s ease;
  }

  .logout-button:hover {
    background-color: rgba(255, 255, 255, 0.1);
  }

  .content {
    flex: 1;
    overflow-y: auto;
    padding: 1rem;
    background-color: var(--background-color);
  }

  .error-message {
    margin-top: 1rem;
    padding: 1rem;
    background-color: rgba(244, 67, 54, 0.1);
    color: #ef5350;
    border-radius: 4px;
    border-left: 4px solid #ef5350;
  }

  /* Make images responsive */
  img {
    max-width: 100%;
    height: auto;
  }

  /* Responsive adjustments for smaller screens */
  @media (max-width: 576px) {
    header h1 {
      font-size: 1.25rem;
    }
    
    .logout-button {
      padding: 0.4rem 0.8rem;
      font-size: 0.8rem;
    }
  }
</style>