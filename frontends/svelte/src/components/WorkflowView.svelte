<script>
  import { createEventDispatcher } from 'svelte';
  import WorkflowDetails from './WorkflowDetails.svelte';
  
  const dispatch = createEventDispatcher();
  
  export let projectId;
  export let projectName = '';
  
  let selectedTask = null;
  let showDetails = false;
  
  // Dummy data for workflow tasks (expanded with description and assignee)
  let workflowTasks = [
    { 
      id: 1, 
      name: 'Complete project setup', 
      description: 'Initialize all project components and ensure all systems are ready',
      assignee: 1,
      status: 'completed', 
      dueDate: '2023-10-15' 
    },
    { 
      id: 2, 
      name: 'Define project parameters', 
      description: 'Set key parameters required for project execution',
      assignee: 2,
      status: 'in-progress', 
      dueDate: '2023-10-20' 
    },
    { 
      id: 3, 
      name: 'Equipment installation review', 
      description: 'Review all installed equipment for compliance and functionality',
      assignee: 3,
      status: 'pending', 
      dueDate: '2023-10-25' 
    },
    { 
      id: 4, 
      name: 'Safety assessment', 
      description: 'Conduct comprehensive safety assessment of all project components',
      assignee: 4,
      status: 'pending', 
      dueDate: '2023-11-01' 
    },
    { 
      id: 5, 
      name: 'Operational tests', 
      description: 'Perform operational testing to ensure project meets requirements',
      assignee: 5,
      status: 'pending', 
      dueDate: '2023-11-10' 
    }
  ];
  
  function getStatusClass(status) {
    switch(status) {
      case 'completed': return 'completed';
      case 'in-progress': return 'in-progress';
      case 'pending': return 'pending';
      default: return '';
    }
  }
  
  function handleBack() {
    dispatch('back');
  }
  
  function openTaskDetails(task) {
    selectedTask = { ...task };
    showDetails = true;
  }
  
  function closeTaskDetails() {
    showDetails = false;
  }
  
  function createNewTask() {
    const newTask = {
      id: workflowTasks.length > 0 ? Math.max(...workflowTasks.map(t => t.id)) + 1 : 1,
      name: '',
      description: '',
      assignee: '',
      status: 'pending',
      dueDate: new Date().toISOString().split('T')[0]
    };
    
    selectedTask = newTask;
    showDetails = true;
  }
  
  function saveTaskDetails(event) {
    const updatedTask = event.detail;
    
    // Check if it's a new task
    const index = workflowTasks.findIndex(t => t.id === updatedTask.id);
    if (index === -1) {
      // Add new task
      workflowTasks = [...workflowTasks, updatedTask];
    } else {
      // Update existing task
      workflowTasks[index] = updatedTask;
      // Force reactivity update
      workflowTasks = [...workflowTasks];
    }
    
    closeTaskDetails();
  }
</script>

<div class="workflow-view">
  <div class="header">
    <button class="back-button" on:click={handleBack}>
      <svg viewBox="0 0 24 24" width="24" height="24">
        <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
      </svg>
    </button>
    <h1>{projectName} Workflow</h1>
  </div>
  
  <div class="task-list">
    {#each workflowTasks as task}
      <div class="task-item" on:click={() => openTaskDetails(task)}>
        <div class="task-status {getStatusClass(task.status)}"></div>
        <div class="task-details">
          <h3>{task.name}</h3>
          <p class="task-date">Due: {task.dueDate}</p>
        </div>
        <div class="task-status-label {getStatusClass(task.status)}">
          {task.status}
        </div>
      </div>
    {/each}
  </div>

  <button class="add-task-button" on:click={createNewTask}>
    <svg viewBox="0 0 24 24" width="24" height="24">
      <path fill="currentColor" d="M19,13H13V19H11V13H5V11H11V5H13V11H19V13Z" />
    </svg>
    Add Task
  </button>
  
  {#if showDetails}
    <div class="modal-overlay">
      <div class="modal-content">
        <WorkflowDetails 
          task={selectedTask} 
          on:save={saveTaskDetails} 
          on:cancel={closeTaskDetails} 
        />
      </div>
    </div>
  {/if}
</div>

<style>
  .workflow-view {
    padding: 16px;
    max-width: 800px;
    margin: 0 auto;
    position: relative;
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
  
  .task-list {
    display: flex;
    flex-direction: column;
    gap: 16px;
    margin-bottom: 24px;
  }
  
  .task-item {
    display: flex;
    align-items: center;
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    cursor: pointer;
    transition: transform 0.2s, box-shadow 0.2s;
  }
  
  .task-item:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,0,0,0.3);
  }
  
  .task-status {
    width: 16px;
    height: 16px;
    border-radius: 50%;
    margin-right: 16px;
  }
  
  .task-status.completed {
    background-color: #4CAF50;
  }
  
  .task-status.in-progress {
    background-color: #2196F3;
  }
  
  .task-status.pending {
    background-color: #9E9E9E;
  }
  
  .task-details {
    flex: 1;
  }
  
  .task-details h3 {
    margin: 0 0 4px 0;
    font-size: 18px;
    color: var(--text-color);
  }
  
  .task-date {
    margin: 0;
    font-size: 14px;
    color: var(--text-light);
  }
  
  .task-status-label {
    font-size: 14px;
    text-transform: capitalize;
    padding: 4px 8px;
    border-radius: 4px;
    margin-left: 16px;
  }
  
  .task-status-label.completed {
    background-color: rgba(76, 175, 80, 0.1);
    color: #81C784;
  }
  
  .task-status-label.in-progress {
    background-color: rgba(33, 150, 243, 0.1);
    color: #64B5F6;
  }
  
  .task-status-label.pending {
    background-color: rgba(158, 158, 158, 0.1);
    color: #BDBDBD;
  }
  
  .add-task-button {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 12px 20px;
    background-color: var(--primary-color, #2196F3);
    color: white;
    border: none;
    border-radius: 8px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s;
  }
  
  .add-task-button:hover {
    background-color: var(--primary-color-dark, #1976D2);
  }
  
  .modal-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: rgba(0, 0, 0, 0.5);
    display: flex;
    justify-content: center;
    align-items: center;
    z-index: 1000;
  }
  
  .modal-content {
    width: 90%;
    max-width: 600px;
    max-height: 90vh;
    overflow-y: auto;
  }
</style> 