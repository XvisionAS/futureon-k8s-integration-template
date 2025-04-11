<script>
  import { createEventDispatcher } from 'svelte';
  import SchematicViewDetails from './SchematicViewDetails.svelte';
  const dispatch = createEventDispatcher();
  
  export let projectId;
  export let projectName = '';
  
  // Dummy data for schematics
  const schematics = [
    { id: 1, name: 'Platform layout', type: 'layout', lastModified: '2023-09-15', creator: 'John Smith' },
    { id: 2, name: 'Subsea connections', type: 'connection', lastModified: '2023-09-20', creator: 'Maria Garcia' },
    { id: 3, name: 'Wellhead assembly', type: 'assembly', lastModified: '2023-09-22', creator: 'David Chen' },
    { id: 4, name: 'FPSO internal diagram', type: 'internal', lastModified: '2023-09-25', creator: 'Sarah Johnson' },
    { id: 5, name: 'Pipeline network', type: 'network', lastModified: '2023-09-28', creator: 'Robert Lee' }
  ];
  
  // State to track which schematic is currently being viewed in detail
  let selectedSchematicId = null;
  
  function getSchematicIcon(type) {
    switch(type) {
      case 'layout':
        return '<path fill="currentColor" d="M3,3H21V5H3V3M3,7H21V9H3V7M3,11H21V13H3V11M3,15H21V17H3V15M3,19H21V21H3V19Z" />';
      case 'connection':
        return '<path fill="currentColor" d="M13,17.25C13,18.22 13.3,19.14 13.84,19.88L13,21L14.5,22.5L16,21L15.16,19.88C15.7,19.14 16,18.22 16,17.25C16,17.12 16,17 15.96,16.88L20,14.74V8C20,6.9 19.11,6 18,6H15.27L20,3V1L12,5.25V7H9.27L4,4V6L8.97,8.94C8.41,9.65 8,10.57 8,11.59C8,14.07 10.07,16.13 12.56,16.13C12.71,16.13 12.86,16.13 13,16.11V17.25M10.5,11.59C10.5,10.8 11.14,10.15 11.93,10.15C12.73,10.15 13.36,10.8 13.36,11.59C13.36,12.38 12.73,13 11.93,13C11.14,13 10.5,12.38 10.5,11.59Z" />';
      case 'assembly':
        return '<path fill="currentColor" d="M2.29,18.96C2.33,19.93 3.27,20.76 4.4,20.58C5.25,20.45 5.91,19.76 6,18.9V18.9L13.87,13.67L20.66,17.26C20.66,17.26 20.92,17.34 21.13,17.14C21.33,16.95 21.26,16.66 21.26,16.66L18.92,5.47C18.92,5.47 18.83,5.16 18.59,5.08C18.34,5 18.16,5.24 18.16,5.24L2.57,18.33C2.57,18.33 2.27,18.56 2.29,18.96M11.06,12V7.5L16,5.46V10.09L11.06,12M4.94,14.37V10.84L9.67,9.06V13.32L4.94,14.37Z" />';
      case 'internal':
        return '<path fill="currentColor" d="M7.5,5.6L5,7L7.5,8.4L6.5,9.1L3.5,7.5V7L3.6,6.9L6.5,4.9L7.5,5.6M10.5,4.9L13.4,6.9L13.5,7L13.4,7.1L10.5,9.1L9.5,8.4L12,7L9.5,5.6L10.5,4.9M15,7.5L16.5,9.1L15.5,9.8L13,8.4V7.4L15.5,6L16.5,6.7L15,7.5M7.5,10.9L9.5,12.5L9.4,12.6L9.5,12.7L7.5,14.4L6.5,13.7L8.3,12.5L6.5,11.3L7.5,10.9M7.5,15.9L5,17.3L7.5,18.7L6.5,19.4L3.5,17.8V16.8L6.5,15.2L7.5,15.9M10.5,15.2L13.5,16.8V17.8L10.5,19.4L9.5,18.7L12,17.3L9.5,15.9L10.5,15.2M15,16.3L16.5,17.9L15.5,18.6L13,17.2V16.2L15.5,14.8L16.5,15.5L15,16.3M16.5,4.9C17.3,4.2 18.5,4.2 19.3,4.9C20,5.7 20,6.9 19.3,7.6L16.5,10.4L13.7,7.6C13,6.9 13,5.7 13.7,4.9C14.5,4.2 15.7,4.2 16.5,4.9M18.6,5.6C18.1,5.2 17.4,5.2 17,5.6C16.6,6 16.6,6.7 17,7.1L18.6,5.6M7.5,13.6C8.3,12.9 9.5,12.9 10.3,13.6C11,14.4 11,15.6 10.3,16.3L7.5,19.1L4.7,16.3C4,15.6 4,14.4 4.7,13.6C5.5,12.9 6.7,12.9 7.5,13.6M9.6,14.3C9.2,13.9 8.5,13.9 8.1,14.3C7.7,14.7 7.7,15.4 8.1,15.8L9.6,14.3Z" />';
      case 'network':
        return '<path fill="currentColor" d="M2,2V8H4.28L5.57,16H4V22H10V16H8.43L7.14,8H8.35L11.13,15H10V22H16V15H14.87L17.65,8H18.86L17.57,16H16V22H22V16H20.43L21.72,8H24V2H18V8H19.29L16.47,15H15.53L12.71,8H14V2H8V8H9.29L6.47,15H5.53L2.71,8H4V2H2M4,4H6V6H4V4M10,4H12V6H10V4M18,4H20V6H18V4M6,18H8V20H6V18M12,18H14V20H12V18M18,18H20V20H18V18Z" />';
      default:
        return '<path fill="currentColor" d="M14,2H6A2,2 0 0,0 4,4V20A2,2 0 0,0 6,22H18A2,2 0 0,0 20,20V8L14,2M18,20H6V4H13V9H18V20M8,13.91C6.27,13.91 4.86,15.32 4.86,17.05C4.86,18.78 6.27,20.19 8,20.19C9.73,20.19 11.14,18.78 11.14,17.05C11.14,15.32 9.73,13.91 8,13.91M8,18.91C7,18.91 6.14,18.05 6.14,17.05C6.14,16.05 7,15.19 8,15.19C9,15.19 9.86,16.05 9.86,17.05C9.86,18.05 9,18.91 8,18.91M16,13.91C14.27,13.91 12.86,15.32 12.86,17.05C12.86,18.78 14.27,20.19 16,20.19C17.73,20.19 19.14,18.78 19.14,17.05C19.14,15.32 17.73,13.91 16,13.91M16,18.91C15,18.91 14.14,18.05 14.14,17.05C14.14,16.05 15,15.19 16,15.19C17,15.19 17.86,16.05 17.86,17.05C17.86,18.05 17,18.91 16,18.91M8,7.91C6.27,7.91 4.86,9.32 4.86,11.05C4.86,12.78 6.27,14.19 8,14.19C9.73,14.19 11.14,12.78 11.14,11.05C11.14,9.32 9.73,7.91 8,7.91M8,12.91C7,12.91 6.14,12.05 6.14,11.05C6.14,10.05 7,9.19 8,9.19C9,9.19 9.86,10.05 9.86,11.05C9.86,12.05 9,12.91 8,12.91Z" />';
    }
  }
  
  function formatDate(dateString) {
    const date = new Date(dateString);
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'short', 
      day: 'numeric' 
    });
  }
  
  function handleBack() {
    dispatch('back');
  }
  
  function handleSchematicClick(schematicId) {
    selectedSchematicId = schematicId;
  }
  
  function handleDetailsBack() {
    selectedSchematicId = null;
  }
  
  // Helper function to get the selected schematic data
  function getSelectedSchematic() {
    return schematics.find(s => s.id === selectedSchematicId);
  }
</script>

<div class="schematics-view">
  {#if selectedSchematicId === null}
    <div class="header">
      <button class="back-button" on:click={handleBack}>
        <svg viewBox="0 0 24 24" width="24" height="24">
          <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
        </svg>
      </button>
      <h1>{projectName} Schematics</h1>
    </div>
    
    <div class="schematic-list">
      {#each schematics as schematic}
        <div class="schematic-item" on:click={() => handleSchematicClick(schematic.id)}>
          <div class="schematic-icon {schematic.type}">
            <svg viewBox="0 0 24 24" width="24" height="24">
              {@html getSchematicIcon(schematic.type)}
            </svg>
          </div>
          <div class="schematic-details">
            <h3>{schematic.name}</h3>
            <div class="schematic-meta">
              <p>Last modified: {formatDate(schematic.lastModified)}</p>
              <p>Created by: {schematic.creator}</p>
            </div>
          </div>
          <div class="schematic-action">
            <svg viewBox="0 0 24 24" width="24" height="24">
              <path fill="currentColor" d="M8.59,16.58L13.17,12L8.59,7.41L10,6L16,12L10,18L8.59,16.58Z" />
            </svg>
          </div>
        </div>
      {/each}
    </div>
  {:else}
    {#if getSelectedSchematic()}
      {@const schematic = getSelectedSchematic()}
      <SchematicViewDetails 
        schematicId={schematic.id} 
        schematicName={schematic.name} 
        lastModified={schematic.lastModified}
        creator={schematic.creator}
        on:back={handleDetailsBack} 
      />
    {/if}
  {/if}
</div>

<style>
  .schematics-view {
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
  
  .schematic-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .schematic-item {
    display: flex;
    align-items: center;
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  
  .schematic-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.3);
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .schematic-icon {
    width: 40px;
    height: 40px;
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 8px;
    margin-right: 16px;
  }
  
  .schematic-icon.layout {
    color: #7986CB;
    background-color: rgba(63, 81, 181, 0.2);
  }
  
  .schematic-icon.connection {
    color: #FF8A65;
    background-color: rgba(255, 87, 34, 0.2);
  }
  
  .schematic-icon.assembly {
    color: #CE93D8;
    background-color: rgba(156, 39, 176, 0.2);
  }
  
  .schematic-icon.internal {
    color: #4DD0E1;
    background-color: rgba(0, 188, 212, 0.2);
  }
  
  .schematic-icon.network {
    color: #81C784;
    background-color: rgba(76, 175, 80, 0.2);
  }
  
  .schematic-details {
    flex: 1;
  }
  
  .schematic-details h3 {
    margin: 0 0 8px 0;
    font-size: 18px;
    color: var(--text-color);
  }
  
  .schematic-meta {
    display: flex;
    flex-wrap: wrap;
    gap: 8px 16px;
  }
  
  .schematic-meta p {
    margin: 0;
    font-size: 14px;
    color: var(--text-light);
  }
  
  .schematic-action {
    color: #90CAF9;
    transition: color 0.2s;
  }
  
  .schematic-item:hover .schematic-action {
    color: #2196F3;
  }
</style> 