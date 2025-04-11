<script>
  import { createEventDispatcher } from 'svelte';
  import ObjectDetailsView from './ObjectDetailsView.svelte';
  
  const dispatch = createEventDispatcher();
  
  export let projectId;
  export let projectName = '';
  
  // Selected object state
  let selectedObject = null;
  
  // Handle object selection
  function selectObject(object) {
    selectedObject = object;
  }
  
  // Handle back from details view
  function handleBackFromDetails() {
    selectedObject = null;
  }
  
  // Category states for collapsible sections
  let categoriesExpanded = {
    assets: true,
    connections: true,
    layers: true
  };
  
  // Toggle category expansion
  function toggleCategory(category) {
    categoriesExpanded[category] = !categoriesExpanded[category];
  }
  
  // Dummy data for project objects with category field
  const projectObjects = [
    { 
      id: 1, 
      name: 'FPSO Alpha', 
      type: 'fpso', 
      status: 'operational', 
      location: 'North Sea', 
      category: 'assets',
      description: 'Main floating production storage and offloading vessel',
      source: 'Engineering Database',
      tags: ['production', 'critical', 'offshore'],
      metadata: {
        function: 'Production',
        service: 'Oil processing and storage',
        type: 'FPSO',
        lastUpdated: '2023-05-15',
        customFields: {
          capacity: '120,000 barrels',
          installDate: '2018-03-22',
          operator: 'North Sea Operations Ltd'
        }
      }
    },
    { 
      id: 2, 
      name: 'Subsea Valve B-23', 
      type: 'valve', 
      status: 'operational', 
      location: 'Well 5', 
      category: 'assets',
      description: 'Remote controlled isolation valve',
      source: 'Subsea Layout',
      tags: ['subsea', 'control', 'safety'],
      metadata: {
        function: 'Flow control',
        service: 'Well isolation',
        type: 'Gate valve',
        lastUpdated: '2023-06-10'
      }
    },
    { 
      id: 3, 
      name: 'XMT-472', 
      type: 'xmt', 
      status: 'maintenance', 
      location: 'Well 3', 
      category: 'assets',
      description: 'Christmas tree for subsea well control',
      source: 'Well Schematics',
      tags: ['subsea', 'well', 'maintenance'],
      metadata: {
        function: 'Well control',
        service: 'Production',
        type: 'Horizontal tree',
        lastUpdated: '2023-04-30'
      }
    },
    { 
      id: 4, 
      name: 'Connection Line A', 
      type: 'connection', 
      status: 'operational', 
      location: 'Between Well 3 and FPSO', 
      category: 'connections',
      description: 'Main production flowline',
      source: 'Pipeline Database',
      tags: ['flowline', 'production'],
      metadata: {
        function: 'Transport',
        service: 'Production',
        type: 'Flowline',
        lastUpdated: '2023-03-15'
      }
    },
    { 
      id: 5, 
      name: 'Connection Line B', 
      type: 'connection', 
      status: 'fault', 
      location: 'Between Well 2 and FPSO', 
      category: 'connections',
      description: 'Secondary production flowline with leak detection alert',
      source: 'Pipeline Database',
      tags: ['flowline', 'production', 'fault'],
      metadata: {
        function: 'Transport',
        service: 'Production',
        type: 'Flowline',
        lastUpdated: '2023-07-05'
      }
    },
    { 
      id: 6, 
      name: 'XMT-389', 
      type: 'xmt', 
      status: 'operational', 
      location: 'Well 6', 
      category: 'assets',
      description: 'Christmas tree for high-pressure well',
      source: 'Well Schematics',
      tags: ['subsea', 'well', 'high-pressure'],
      metadata: {
        function: 'Well control',
        service: 'Production',
        type: 'Vertical tree',
        lastUpdated: '2023-05-22'
      }
    },
    { 
      id: 7, 
      name: 'Subsea Layer', 
      type: 'layer', 
      status: 'operational', 
      location: 'Field-wide', 
      category: 'layers',
      description: 'Visualization layer for all subsea equipment',
      source: 'GIS Database',
      tags: ['mapping', 'subsea', 'visualization'],
      metadata: {
        function: 'Visualization',
        service: 'Mapping',
        type: 'GIS Layer',
        lastUpdated: '2023-06-30'
      }
    },
    { 
      id: 8, 
      name: 'Topside Layer', 
      type: 'layer', 
      status: 'operational', 
      location: 'FPSO', 
      category: 'layers',
      description: 'Visualization layer for topside equipment',
      source: 'GIS Database',
      tags: ['mapping', 'topside', 'visualization'],
      metadata: {
        function: 'Visualization',
        service: 'Mapping',
        type: 'GIS Layer',
        lastUpdated: '2023-06-15'
      }
    }
  ];
  
  // Group objects by category
  const groupedObjects = {
    assets: projectObjects.filter(obj => obj.category === 'assets'),
    connections: projectObjects.filter(obj => obj.category === 'connections'),
    layers: projectObjects.filter(obj => obj.category === 'layers')
  };
  
  // Category display names
  const categoryNames = {
    assets: 'Assets',
    connections: 'Connections',
    layers: 'Layers'
  };
  
  // Category icons
  function getCategoryIcon(category) {
    switch(category) {
      case 'assets':
        return '<path fill="currentColor" d="M19,5V7H15V5H19M9,5V11H5V5H9M19,13V19H15V13H19M9,17V19H5V17H9M21,3H13V9H21V3M11,3H3V13H11V3M21,11H13V21H21V11M11,15H3V21H11V15Z" />';
      case 'connections':
        return '<path fill="currentColor" d="M22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2A10,10 0 0,1 22,12M15.6,13.32L16.46,14.88L19.64,16.83L18.32,18.83L15.12,16.87L13.78,15.19V15.19C11.69,16.26 9.07,15.58 7.76,13.59C6.46,11.6 7.13,9.07 9.21,8C11.3,6.93 13.92,7.61 15.23,9.6C16.16,11 16.23,12.82 15.6,13.32Z" />';
      case 'layers':
        return '<path fill="currentColor" d="M12,16L19.36,10.27L21,9L12,2L3,9L4.63,10.27M12,18.54L4.62,12.81L3,14.07L12,21.07L21,14.07L19.37,12.8L12,18.54Z" />';
      default:
        return '<path fill="currentColor" d="M12,2A10,10 0 0,1 22,12A10,10 0 0,1 12,22A10,10 0 0,1 2,12A10,10 0 0,1 12,2M12,4A8,8 0 0,0 4,12A8,8 0 0,0 12,20A8,8 0 0,0 20,12A8,8 0 0,0 12,4Z" />';
    }
  }
  
  function getStatusClass(status) {
    switch(status) {
      case 'operational': return 'operational';
      case 'maintenance': return 'maintenance';
      case 'fault': return 'fault';
      default: return '';
    }
  }
  
  function getObjectIcon(type) {
    switch(type) {
      case 'fpso':
        return '<path fill="currentColor" d="M20,21C20,21.55 19.55,22 19,22H5C4.45,22 4,21.55 4,21V8.5C4,8.22 4.22,8 4.5,8H6.62C7.45,8 8.21,7.38 8.37,6.56L8.77,4.56C8.84,4.23 9.11,4 9.44,4H14.56C14.89,4 15.16,4.23 15.23,4.56L15.63,6.56C15.79,7.38 16.55,8 17.38,8H19.5C19.78,8 20,8.22 20,8.5V21M6.5,10C5.67,10 5,10.67 5,11.5C5,12.33 5.67,13 6.5,13C7.33,13 8,12.33 8,11.5C8,10.67 7.33,10 6.5,10M9,3H15L14.6,1.5H9.4L9,3Z" />';
      case 'valve':
        return '<path fill="currentColor" d="M22,2V4H19V8H22V10H19V14H22V16H19V20H22V22H17C15.9,22 15,21.1 15,20V16H13L12,18.4L11,16H9V20C9,21.1 8.1,22 7,22H2V20H5V16H2V14H5V10H2V8H5V4H2V2H7C8.1,2 9,2.9 9,4V8H11L12,6L13,8H15V4C15,2.9 15.9,2 17,2H22Z" />';
      case 'xmt':
        return '<path fill="currentColor" d="M12,16A3,3 0 0,1 9,13C9,11.88 9.61,10.9 10.5,10.39L20.21,4.77L14.68,14.35C14.18,15.33 13.17,16 12,16M12,3C13.81,3 15.5,3.5 16.97,4.32L14.87,5.53C14,5.19 13,5 12,5A8,8 0 0,0 4,13C4,15.21 4.89,17.21 6.34,18.65H6.35C6.74,19.04 6.74,19.67 6.35,20.06C5.96,20.45 5.32,20.45 4.93,20.07V20.07C3.12,18.26 2,15.76 2,13A10,10 0 0,1 12,3M22,13C22,15.76 20.88,18.26 19.07,20.07V20.07C18.68,20.45 18.05,20.45 17.66,20.06C17.27,19.67 17.27,19.04 17.66,18.65V18.65C19.11,17.2 20,15.21 20,13C20,12 19.81,11 19.46,10.1L20.67,8C21.5,9.5 22,11.18 22,13Z" />';
      case 'connection':
        return '<path fill="currentColor" d="M11.5,15.97L11.91,18.41C11.65,18.55 11.23,18.68 10.67,18.8C10.1,18.93 9.43,19 8.66,19C6.45,18.96 4.79,18.3 3.68,17.04C2.56,15.77 2,14.16 2,12.21C2.05,9.9 2.72,8.13 4,6.89C5.32,5.64 6.96,5 8.94,5C9.69,5 10.34,5.07 10.88,5.19C11.42,5.31 11.82,5.44 12.08,5.59L11.5,8.08L10.44,7.74C10.04,7.64 9.58,7.59 9.05,7.59C7.89,7.58 6.93,7.95 6.18,8.69C5.42,9.42 5.03,10.54 5,12.03C5,13.39 5.37,14.45 6.08,15.23C6.79,16 7.79,16.4 9.07,16.41L10.4,16.29C10.83,16.21 11.19,16.1 11.5,15.97M13.89,19L14.5,15H13L13.34,13H14.84L15.16,11H13.66L14,9H15.5L16.11,5H18.11L17.5,9H19L18.66,11H17.16L16.84,13H18.34L18,15H16.5L15.89,19H13.89M16.67,9H18.17L17.84,11H16.34L16.67,9Z" />';
      case 'layer':
        return '<path fill="currentColor" d="M12,16L19.36,10.27L21,9L12,2L3,9L4.63,10.27M12,18.54L4.62,12.81L3,14.07L12,21.07L21,14.07L19.37,12.8L12,18.54Z" />';
      default:
        return '<path fill="currentColor" d="M11,7H15V9H11V11H13A2,2 0 0,1 15,13V15A2,2 0 0,1 13,17H9V15H13V13H11A2,2 0 0,1 9,11V9A2,2 0 0,1 11,7M5,3H19A2,2 0 0,1 21,5V19A2,2 0 0,1 19,21H5A2,2 0 0,1 3,19V5A2,2 0 0,1 5,3Z" />';
    }
  }
  
  function handleBack() {
    dispatch('back');
  }
</script>

<div class="objects-view">
  {#if selectedObject}
    <ObjectDetailsView object={selectedObject} on:back={handleBackFromDetails} />
  {:else}
    <div class="header">
      <button class="back-button" on:click={handleBack}>
        <svg viewBox="0 0 24 24" width="24" height="24">
          <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
        </svg>
      </button>
      <h1>{projectName} Objects</h1>
    </div>
    
    <div class="category-list">
      {#each Object.keys(groupedObjects) as category}
        <div class="category-container">
          <div class="category-header" on:click={() => toggleCategory(category)}>
            <div class="category-icon">
              <svg viewBox="0 0 24 24" width="24" height="24">
                {@html getCategoryIcon(category)}
              </svg>
            </div>
            <h2>{categoryNames[category]} ({groupedObjects[category].length})</h2>
            <div class="category-toggle-icon">
              <svg viewBox="0 0 24 24" width="20" height="20">
                <path fill="currentColor" d={categoriesExpanded[category] ? 
                  "M7.41,15.41L12,10.83L16.59,15.41L18,14L12,8L6,14L7.41,15.41Z" : 
                  "M7.41,8.58L12,13.17L16.59,8.58L18,10L12,16L6,10L7.41,8.58Z"} />
              </svg>
            </div>
          </div>
          
          {#if categoriesExpanded[category]}
            <div class="object-list">
              {#each groupedObjects[category] as object}
                <div class="object-item" on:click={() => selectObject(object)}>
                  <div class="object-icon {object.type}">
                    <svg viewBox="0 0 24 24" width="24" height="24">
                      {@html getObjectIcon(object.type)}
                    </svg>
                  </div>
                  <div class="object-details">
                    <h3>{object.name}</h3>
                    <p class="object-location">Location: {object.location}</p>
                  </div>
                  <div class="object-status-label {getStatusClass(object.status)}">
                    {object.status}
                  </div>
                </div>
              {/each}
            </div>
          {/if}
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .objects-view {
    padding: 16px;
    max-width: 800px;
    margin: 0 auto;
  }
  
  .header {
    display: flex;
    align-items: center;
    margin-bottom: 24px;
  }
  
  .back-button {
    display: flex;
    justify-content: center;
    align-items: center;
    width: 40px;
    height: 40px;
    border-radius: 50%;
    border: none;
    background-color: rgba(255, 255, 255, 0.05);
    margin-right: 16px;
    cursor: pointer;
    transition: background-color 0.2s;
  }
  
  .back-button:hover {
    background-color: rgba(255, 255, 255, 0.1);
  }
  
  h1 {
    font-size: 24px;
    margin: 0;
    color: var(--text-color);
  }
  
  .category-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .category-container {
    background-color: var(--card-color);
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .category-header {
    display: flex;
    align-items: center;
    padding: 16px;
    cursor: pointer;
    background-color: rgba(255, 255, 255, 0.03);
    transition: background-color 0.2s;
  }
  
  .category-header:hover {
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .category-icon {
    width: 32px;
    height: 32px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    margin-right: 16px;
    background-color: rgba(255, 255, 255, 0.1);
    color: var(--text-color);
  }
  
  .category-header h2 {
    font-size: 18px;
    margin: 0;
    color: var(--text-color);
    flex: 1;
  }
  
  .category-toggle-icon {
    color: var(--text-light);
  }
  
  .object-list {
    display: flex;
    flex-direction: column;
  }
  
  .object-item {
    display: flex;
    align-items: center;
    padding: 16px;
    border-top: 1px solid rgba(255, 255, 255, 0.05);
    cursor: pointer;
    transition: background-color 0.2s;
  }
  
  .object-item:hover {
    background-color: rgba(255, 255, 255, 0.02);
  }
  
  .object-icon {
    width: 40px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 50%;
    margin-right: 16px;
  }
  
  .object-icon.fpso {
    color: #7986CB;
    background-color: rgba(63, 81, 181, 0.2);
  }
  
  .object-icon.valve {
    color: #FF8A65;
    background-color: rgba(255, 87, 34, 0.2);
  }
  
  .object-icon.xmt {
    color: #CE93D8;
    background-color: rgba(156, 39, 176, 0.2);
  }
  
  .object-icon.connection {
    color: #4DD0E1;
    background-color: rgba(0, 188, 212, 0.2);
  }
  
  .object-icon.layer {
    color: #AED581;
    background-color: rgba(139, 195, 74, 0.2);
  }
  
  .object-details {
    flex: 1;
  }
  
  .object-details h3 {
    margin: 0 0 4px 0;
    font-size: 18px;
    color: var(--text-color);
  }
  
  .object-location {
    margin: 0;
    font-size: 14px;
    color: var(--text-light);
  }
  
  .object-status-label {
    font-size: 14px;
    text-transform: capitalize;
    padding: 4px 8px;
    border-radius: 4px;
    margin-left: 16px;
  }
  
  .object-status-label.operational {
    background-color: rgba(76, 175, 80, 0.1);
    color: #81C784;
  }
  
  .object-status-label.maintenance {
    background-color: rgba(255, 152, 0, 0.1);
    color: #FFB74D;
  }
  
  .object-status-label.fault {
    background-color: rgba(244, 67, 54, 0.1);
    color: #E57373;
  }
</style> 