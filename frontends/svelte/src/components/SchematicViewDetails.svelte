<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  
  export let schematicId;
  export let schematicName = '';
  export let lastModified = '';
  export let creator = '';
  
  // Dummy revision history data
  const revisionHistory = [
    { date: '2023-09-28', user: 'Robert Lee', changes: 'Updated connection points' },
    { date: '2023-09-25', user: 'Maria Garcia', changes: 'Added power distribution module' },
    { date: '2023-09-22', user: 'John Smith', changes: 'Initial draft creation' }
  ];
  
  // Generate a random electronic circuit SVG based on schematic ID
  function generateCircuitSVG(id) {
    // Using schematic ID to deterministically generate a circuit pattern
    const circuitPatterns = [
      // Circuit 1: Power Distribution Network
      `<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
        <rect x="50" y="50" width="700" height="400" fill="none" stroke="#2196F3" stroke-width="2" />
        <circle cx="150" cy="150" r="30" fill="none" stroke="#FF8A65" stroke-width="2" />
        <circle cx="650" cy="150" r="30" fill="none" stroke="#FF8A65" stroke-width="2" />
        <circle cx="150" cy="350" r="30" fill="none" stroke="#FF8A65" stroke-width="2" />
        <circle cx="650" cy="350" r="30" fill="none" stroke="#FF8A65" stroke-width="2" />
        <line x1="150" y1="180" x2="150" y2="320" stroke="#2196F3" stroke-width="3" />
        <line x1="650" y1="180" x2="650" y2="320" stroke="#2196F3" stroke-width="3" />
        <line x1="180" y1="150" x2="620" y2="150" stroke="#2196F3" stroke-width="3" />
        <line x1="180" y1="350" x2="620" y2="350" stroke="#2196F3" stroke-width="3" />
        <rect x="350" y="200" width="100" height="100" fill="none" stroke="#81C784" stroke-width="2" />
        <line x1="350" y1="250" x2="300" y2="250" stroke="#2196F3" stroke-width="2" />
        <line x1="450" y1="250" x2="500" y2="250" stroke="#2196F3" stroke-width="2" />
        <line x1="400" y1="200" x2="400" y2="150" stroke="#2196F3" stroke-width="2" />
        <line x1="400" y1="300" x2="400" y2="350" stroke="#2196F3" stroke-width="2" />
        <text x="380" y="250" font-size="14" fill="#FFFFFF">CPU</text>
      </svg>`,
      
      // Circuit 2: Microcontroller with Peripherals
      `<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
        <rect x="300" y="200" width="200" height="100" fill="none" stroke="#CE93D8" stroke-width="2" />
        <text x="350" y="250" font-size="14" fill="#FFFFFF">MCU</text>
        
        <rect x="100" y="100" width="100" height="60" fill="none" stroke="#4DD0E1" stroke-width="2" />
        <text x="120" y="130" font-size="12" fill="#FFFFFF">Sensor 1</text>
        
        <rect x="100" y="300" width="100" height="60" fill="none" stroke="#4DD0E1" stroke-width="2" />
        <text x="120" y="330" font-size="12" fill="#FFFFFF">Sensor 2</text>
        
        <rect x="600" y="100" width="100" height="60" fill="none" stroke="#FF8A65" stroke-width="2" />
        <text x="620" y="130" font-size="12" fill="#FFFFFF">Output 1</text>
        
        <rect x="600" y="300" width="100" height="60" fill="none" stroke="#FF8A65" stroke-width="2" />
        <text x="620" y="330" font-size="12" fill="#FFFFFF">Output 2</text>
        
        <line x1="200" y1="130" x2="300" y2="220" stroke="#2196F3" stroke-width="2" />
        <line x1="200" y1="330" x2="300" y2="280" stroke="#2196F3" stroke-width="2" />
        <line x1="500" y1="220" x2="600" y2="130" stroke="#2196F3" stroke-width="2" />
        <line x1="500" y1="280" x2="600" y2="330" stroke="#2196F3" stroke-width="2" />
        
        <circle cx="300" cy="220" r="5" fill="#81C784" />
        <circle cx="300" cy="280" r="5" fill="#81C784" />
        <circle cx="500" cy="220" r="5" fill="#81C784" />
        <circle cx="500" cy="280" r="5" fill="#81C784" />
      </svg>`,
      
      // Circuit 3: Logic Gate Network
      `<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
        <path d="M 100,100 L 150,100 L 150,150 L 100,150 Z" fill="none" stroke="#7986CB" stroke-width="2" />
        <path d="M 100,200 L 150,200 L 150,250 L 100,250 Z" fill="none" stroke="#7986CB" stroke-width="2" />
        <path d="M 100,300 L 150,300 L 150,350 L 100,350 Z" fill="none" stroke="#7986CB" stroke-width="2" />
        
        <path d="M 250,150 L 300,150 L 325,175 L 300,200 L 250,200 L 250,150 Z" fill="none" stroke="#FF8A65" stroke-width="2" />
        <path d="M 250,300 L 300,300 L 325,325 L 300,350 L 250,350 L 250,300 Z" fill="none" stroke="#FF8A65" stroke-width="2" />
        
        <path d="M 425,225 L 475,225 L 500,250 L 475,275 L 425,275 L 400,250 L 425,225 Z" fill="none" stroke="#CE93D8" stroke-width="2" />
        
        <path d="M 600,250 L 650,250 L 650,300 L 600,300 Z" fill="none" stroke="#81C784" stroke-width="2" />
        
        <line x1="150" y1="125" x2="250" y2="175" stroke="#2196F3" stroke-width="2" />
        <line x1="150" y1="225" x2="250" y2="175" stroke="#2196F3" stroke-width="2" />
        <line x1="150" y1="325" x2="250" y2="325" stroke="#2196F3" stroke-width="2" />
        
        <line x1="325" y1="175" x2="400" y2="250" stroke="#2196F3" stroke-width="2" />
        <line x1="325" y1="325" x2="400" y2="250" stroke="#2196F3" stroke-width="2" />
        
        <line x1="500" y1="250" x2="600" y2="275" stroke="#2196F3" stroke-width="2" />
        
        <text x="115" y="125" font-size="12" fill="#FFFFFF">IN1</text>
        <text x="115" y="225" font-size="12" fill="#FFFFFF">IN2</text>
        <text x="115" y="325" font-size="12" fill="#FFFFFF">IN3</text>
        <text x="270" y="175" font-size="12" fill="#FFFFFF">AND</text>
        <text x="270" y="325" font-size="12" fill="#FFFFFF">OR</text>
        <text x="440" y="250" font-size="12" fill="#FFFFFF">XOR</text>
        <text x="615" y="275" font-size="12" fill="#FFFFFF">OUT</text>
      </svg>`,
      
      // Circuit 4: Memory Module
      `<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
        <rect x="100" y="100" width="600" height="300" fill="none" stroke="#2196F3" stroke-width="2" />
        
        <rect x="150" y="150" width="200" height="200" fill="none" stroke="#CE93D8" stroke-width="2" />
        <text x="190" y="250" font-size="16" fill="#FFFFFF">RAM</text>
        
        <rect x="450" y="150" width="200" height="200" fill="none" stroke="#FF8A65" stroke-width="2" />
        <text x="490" y="250" font-size="16" fill="#FFFFFF">ROM</text>
        
        <line x1="150" y1="180" x2="100" y2="180" stroke="#81C784" stroke-width="2" />
        <line x1="150" y1="220" x2="100" y2="220" stroke="#81C784" stroke-width="2" />
        <line x1="150" y1="260" x2="100" y2="260" stroke="#81C784" stroke-width="2" />
        <line x1="150" y1="300" x2="100" y2="300" stroke="#81C784" stroke-width="2" />
        
        <line x1="450" y1="180" x2="400" y2="180" stroke="#81C784" stroke-width="2" />
        <line x1="450" y1="220" x2="400" y2="220" stroke="#81C784" stroke-width="2" />
        <line x1="450" y1="260" x2="400" y2="260" stroke="#81C784" stroke-width="2" />
        <line x1="450" y1="300" x2="400" y2="300" stroke="#81C784" stroke-width="2" />
        
        <line x1="350" y1="180" x2="400" y2="180" stroke="#81C784" stroke-width="2" />
        <line x1="350" y1="220" x2="400" y2="220" stroke="#81C784" stroke-width="2" />
        <line x1="350" y1="260" x2="400" y2="260" stroke="#81C784" stroke-width="2" />
        <line x1="350" y1="300" x2="400" y2="300" stroke="#81C784" stroke-width="2" />
        
        <line x1="650" y1="180" x2="700" y2="180" stroke="#81C784" stroke-width="2" />
        <line x1="650" y1="220" x2="700" y2="220" stroke="#81C784" stroke-width="2" />
        <line x1="650" y1="260" x2="700" y2="260" stroke="#81C784" stroke-width="2" />
        <line x1="650" y1="300" x2="700" y2="300" stroke="#81C784" stroke-width="2" />
        
        <text x="120" y="180" font-size="10" fill="#FFFFFF">A0</text>
        <text x="120" y="220" font-size="10" fill="#FFFFFF">A1</text>
        <text x="120" y="260" font-size="10" fill="#FFFFFF">D0</text>
        <text x="120" y="300" font-size="10" fill="#FFFFFF">D1</text>
        
        <text x="670" y="180" font-size="10" fill="#FFFFFF">Q0</text>
        <text x="670" y="220" font-size="10" fill="#FFFFFF">Q1</text>
        <text x="670" y="260" font-size="10" fill="#FFFFFF">Q2</text>
        <text x="670" y="300" font-size="10" fill="#FFFFFF">Q3</text>
      </svg>`,
      
      // Circuit 5: Signal Processing Circuit
      `<svg viewBox="0 0 800 500" xmlns="http://www.w3.org/2000/svg">
        <rect x="100" y="100" width="100" height="60" fill="none" stroke="#4DD0E1" stroke-width="2" />
        <text x="115" y="130" font-size="12" fill="#FFFFFF">INPUT</text>
        
        <rect x="300" y="100" width="100" height="60" fill="none" stroke="#7986CB" stroke-width="2" />
        <text x="320" y="130" font-size="12" fill="#FFFFFF">AMP</text>
        
        <rect x="300" y="250" width="100" height="60" fill="none" stroke="#CE93D8" stroke-width="2" />
        <text x="320" y="280" font-size="12" fill="#FFFFFF">FILTER</text>
        
        <rect x="500" y="175" width="100" height="60" fill="none" stroke="#FF8A65" stroke-width="2" />
        <text x="520" y="205" font-size="12" fill="#FFFFFF">ADC</text>
        
        <rect x="650" y="175" width="100" height="60" fill="none" stroke="#81C784" stroke-width="2" />
        <text x="660" y="205" font-size="12" fill="#FFFFFF">OUTPUT</text>
        
        <line x1="200" y1="130" x2="300" y2="130" stroke="#2196F3" stroke-width="2" />
        <line x1="400" y1="130" x2="450" y2="130" stroke="#2196F3" stroke-width="2" />
        <line x1="450" y1="130" x2="450" y2="280" stroke="#2196F3" stroke-width="2" />
        <line x1="400" y1="280" x2="450" y2="280" stroke="#2196F3" stroke-width="2" />
        <line x1="450" y1="205" x2="500" y2="205" stroke="#2196F3" stroke-width="2" />
        <line x1="600" y1="205" x2="650" y2="205" stroke="#2196F3" stroke-width="2" />
        <line x1="250" y1="280" x2="300" y2="280" stroke="#2196F3" stroke-width="2" />
        <line x1="250" y1="280" x2="250" y2="130" stroke="#2196F3" stroke-width="2" />
        
        <circle cx="250" cy="130" r="5" fill="#81C784" />
        <circle cx="450" cy="130" r="5" fill="#81C784" />
        <circle cx="450" cy="205" r="5" fill="#81C784" />
        <circle cx="450" cy="280" r="5" fill="#81C784" />
      </svg>`
    ];
    
    return circuitPatterns[id % 5];
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
</script>

<div class="schematic-details-view">
  <div class="header">
    <button class="back-button" on:click={handleBack}>
      <svg viewBox="0 0 24 24" width="24" height="24">
        <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
      </svg>
    </button>
    <h1>{schematicName}</h1>
  </div>
  
  <div class="schematic-info">
    <p><strong>Last Modified:</strong> {formatDate(lastModified)}</p>
    <p><strong>Created by:</strong> {creator}</p>
  </div>
  
  <div class="schematic-content">
    <div class="circuit-container">
      {@html generateCircuitSVG(schematicId)}
    </div>
  </div>
  
  <div class="revision-history">
    <h2>Revision History</h2>
    <div class="history-items">
      {#each revisionHistory as revision}
        <div class="history-item">
          <div class="history-date">{formatDate(revision.date)}</div>
          <div class="history-user">{revision.user}</div>
          <div class="history-changes">{revision.changes}</div>
        </div>
      {/each}
    </div>
  </div>
</div>

<style>
  .schematic-details-view {
    padding: 16px;
    max-width: 1000px;
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
  
  h2 {
    font-size: 20px;
    margin: 0 0 16px 0;
    color: var(--text-color);
  }
  
  .schematic-info {
    margin-bottom: 24px;
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .schematic-info p {
    margin: 8px 0;
    font-size: 16px;
    color: var(--text-light);
  }
  
  .schematic-info strong {
    color: var(--text-color);
  }
  
  .schematic-content {
    margin-bottom: 24px;
  }
  
  .circuit-container {
    width: 100%;
    height: 500px;
    background-color: #1E1E1E;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    overflow: hidden;
  }
  
  .circuit-container svg {
    width: 100%;
    height: 100%;
  }
  
  .revision-history {
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
  }
  
  .history-items {
    display: flex;
    flex-direction: column;
    gap: 12px;
  }
  
  .history-item {
    display: grid;
    grid-template-columns: 1fr 1fr 2fr;
    gap: 16px;
    padding: 12px;
    border-radius: 4px;
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .history-date {
    color: #90CAF9;
  }
  
  .history-user {
    color: #CE93D8;
  }
  
  .history-changes {
    color: var(--text-light);
  }
  
  @media (max-width: 768px) {
    .history-item {
      grid-template-columns: 1fr;
      gap: 8px;
    }
  }
</style> 