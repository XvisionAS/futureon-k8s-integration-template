<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  
  export let object = null; // The object to display
  
  // Tabs configuration
  const tabs = [
    { id: 'common', label: 'Common' },
    { id: 'metadata', label: 'Metadata' }
  ];
  
  // Active tab state
  let activeTab = 'common';
  
  // Handle tab change
  function setActiveTab(tabId) {
    activeTab = tabId;
  }
  
  // Handle back button click
  function handleBack() {
    dispatch('back');
  }
  
  // Dummy metadata if not provided
  $: metadata = object?.metadata || {
    function: 'Production',
    service: 'Oil export',
    type: 'Processing equipment'
  };
  
  // Dummy tags if not provided
  $: tags = object?.tags || ['offshore', 'north-sea', 'critical'];
</script>

<div class="object-details-view">
  <div class="header">
    <button class="back-button" on:click={handleBack}>
      <svg viewBox="0 0 24 24" width="24" height="24">
        <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
      </svg>
    </button>
    <h1>{object?.name || 'Object Details'}</h1>
  </div>
  
  {#if object}
    <div class="object-summary">
      <div class="object-icon {object.type}">
        <svg viewBox="0 0 24 24" width="32" height="32">
          <!-- Replace with actual icon path based on object type -->
          <path fill="currentColor" d="M12,3L2,12H5V20H19V12H22L12,3M12,8.5C14.34,8.5 16.46,9.43 18,10.94L16.8,12.12C15.58,10.91 13.88,10.17 12,10.17C10.12,10.17 8.42,10.91 7.2,12.12L6,10.94C7.54,9.43 9.66,8.5 12,8.5M12,11.83C13.4,11.83 14.67,12.39 15.6,13.3L14.4,14.47C13.79,13.87 12.94,13.5 12,13.5C11.06,13.5 10.21,13.87 9.6,14.47L8.4,13.3C9.33,12.39 10.6,11.83 12,11.83M12,15.17C12.94,15.17 13.7,15.91 13.7,16.83C13.7,17.75 12.94,18.5 12,18.5C11.06,18.5 10.3,17.75 10.3,16.83C10.3,15.91 11.06,15.17 12,15.17Z" />
        </svg>
      </div>
      <div class="object-summary-details">
        <div class="object-id">ID: {object.id}</div>
        <div class="object-status-label {object.status}">
          {object.status}
        </div>
      </div>
    </div>
    
    <div class="tabs-container">
      <div class="tabs-header">
        {#each tabs as tab}
          <button 
            class="tab-button {activeTab === tab.id ? 'active' : ''}" 
            on:click={() => setActiveTab(tab.id)}
          >
            {tab.label}
          </button>
        {/each}
      </div>
      
      <div class="tab-content">
        {#if activeTab === 'common'}
          <div class="common-properties">
            <div class="property-group">
              <h3>Basic Information</h3>
              
              <div class="property-item">
                <div class="property-label">Name</div>
                <div class="property-value">{object.name}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Label</div>
                <div class="property-value">{object.label || object.name}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Description</div>
                <div class="property-value">{object.description || 'No description available'}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Location</div>
                <div class="property-value">{object.location}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Source</div>
                <div class="property-value">{object.source || 'FieldTwin Database'}</div>
              </div>
            </div>
            
            <div class="property-group">
              <h3>Tags</h3>
              <div class="tags-container">
                {#each tags as tag}
                  <span class="tag">{tag}</span>
                {/each}
              </div>
            </div>
          </div>
        {:else if activeTab === 'metadata'}
          <div class="metadata-properties">
            <div class="property-group">
              <h3>Technical Metadata</h3>
              
              <div class="property-item">
                <div class="property-label">Function</div>
                <div class="property-value">{metadata.function}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Service</div>
                <div class="property-value">{metadata.service}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Type</div>
                <div class="property-value">{metadata.type}</div>
              </div>
              
              <div class="property-item">
                <div class="property-label">Last Updated</div>
                <div class="property-value">{metadata.lastUpdated || 'Unknown'}</div>
              </div>
            </div>
            
            {#if metadata.customFields}
              <div class="property-group">
                <h3>Custom Fields</h3>
                {#each Object.entries(metadata.customFields) as [key, value]}
                  <div class="property-item">
                    <div class="property-label">{key}</div>
                    <div class="property-value">{value}</div>
                  </div>
                {/each}
              </div>
            {/if}
          </div>
        {/if}
      </div>
    </div>
  {:else}
    <div class="no-object-selected">
      <p>No object selected</p>
    </div>
  {/if}
</div>

<style>
  .object-details-view {
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
  
  .object-summary {
    display: flex;
    align-items: center;
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    margin-bottom: 24px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .object-icon {
    width: 56px;
    height: 56px;
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
  
  .object-summary-details {
    flex: 1;
  }
  
  .object-id {
    font-size: 14px;
    color: var(--text-light);
    margin-bottom: 8px;
  }
  
  .object-status-label {
    display: inline-block;
    font-size: 14px;
    text-transform: capitalize;
    padding: 4px 8px;
    border-radius: 4px;
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
  
  .tabs-container {
    background-color: var(--card-color);
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .tabs-header {
    display: flex;
    border-bottom: 1px solid rgba(255, 255, 255, 0.1);
  }
  
  .tab-button {
    padding: 12px 16px;
    background: none;
    border: none;
    font-size: 16px;
    color: var(--text-light);
    cursor: pointer;
    transition: all 0.2s;
    flex: 1;
    text-align: center;
  }
  
  .tab-button:hover {
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .tab-button.active {
    color: var(--text-color);
    border-bottom: 2px solid var(--primary-color, #4DD0E1);
    background-color: rgba(255, 255, 255, 0.02);
  }
  
  .tab-content {
    padding: 24px;
  }
  
  .property-group {
    margin-bottom: 24px;
  }
  
  .property-group h3 {
    font-size: 18px;
    margin: 0 0 16px 0;
    color: var(--text-color);
    font-weight: 500;
  }
  
  .property-item {
    display: flex;
    margin-bottom: 12px;
    padding-bottom: 12px;
    border-bottom: 1px solid rgba(255, 255, 255, 0.05);
  }
  
  .property-item:last-child {
    border-bottom: none;
  }
  
  .property-label {
    width: 120px;
    font-size: 14px;
    color: var(--text-light);
  }
  
  .property-value {
    flex: 1;
    font-size: 14px;
    color: var(--text-color);
  }
  
  .tags-container {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
  }
  
  .tag {
    font-size: 12px;
    padding: 4px 8px;
    border-radius: 4px;
    background-color: rgba(255, 255, 255, 0.05);
    color: var(--text-light);
  }
  
  .no-object-selected {
    display: flex;
    justify-content: center;
    align-items: center;
    padding: 48px;
    background-color: var(--card-color);
    border-radius: 8px;
    color: var(--text-light);
  }
</style> 