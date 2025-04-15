<script>
  import { version } from '../package.json';

  import 'bootstrap/dist/css/bootstrap.min.css';
  import { InfoCircle } from "svelte-bootstrap-icons";

  import AdminService from './actions/AdminService';
  import DocumentList from './components/DocumentList.svelte';

  let token = $state('');
  let loaded = $derived(!!token);

  let documents = $state([]);

  $effect(() => {
    if (!loaded && window.loadedEvent) {
      const data = window.loadedEvent
      triggerLoad(data.token)
    }
  });

  async function triggerLoad(jwtToken, projectId, subProjectId) {
    AdminService.setJWT(jwtToken)
    AdminService.setProject(projectId, subProjectId)
    documents = await AdminService.getDocuments()
    token = jwtToken
  }

  function loadCSS(cssUrl, cssThemeUrl) {
    // Helper function to create and append a stylesheet link
    const addStylesheet = (url) => {
      if (!url) return;
      
      // Check if stylesheet already exists
      const existingLinks = document.querySelectorAll('link[rel="stylesheet"]');
      for (const link of existingLinks) {
        if (link.href === url) return; // Skip if already loaded
      }
      
      const link = document.createElement('link');
      link.rel = 'stylesheet';
      link.href = url;
      document.head.appendChild(link);
      console.log(`Loaded CSS: ${url}`);
    };
    
    // Load both stylesheets
    addStylesheet(cssUrl);
    addStylesheet(cssThemeUrl);
  }

  function onWindowMessage(msg) {
    if (!loaded && msg.data?.event === 'loaded') {
      console.log('Message received:', msg)
      triggerLoad(msg.data.token, msg.data.project, msg.data.subProject)
      // Load CSS files if provided
      loadCSS(msg.data.cssUrl, msg.data.cssThemeUrl);
    }
    if (!msg.data.isFrameActive) {
      return
    }
  }
</script>

<svelte:window on:message={onWindowMessage} />

<main class="app" style="padding: 20px 80px; padding-bottom: 180px;">
  {#if loaded}
    <div class="container mt-4">
      <div class="row">
        <div class="col-12">
          <DocumentList documents={documents} />
        </div>
      </div>
    </div>
  {:else}
    <div class="container mt-4">
      <div class="alert alert-info" role="alert">
        Waiting for integration to load...
      </div>
    </div>
  {/if}

  <div class="footer-container bg-dark text-secondary mt-3">
    <div class="container mt-3">
      <div class="mt-3">
        <div class="text-end small"><InfoCircle />v{version}, Powered by <a href="https://api.fieldtwin.com/" target="_blank"><img src="https://avatars.githubusercontent.com/u/12692713?s=48&v=4" alt="" class="img-thumbnail" style="height:25px" title="FieldTwin API"></a>
        </div>
      </div>
    </div>
  </div>
</main>

<style>

</style>