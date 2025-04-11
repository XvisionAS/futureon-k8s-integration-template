<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  
  export let task = {
    id: null,
    name: '',
    description: '',
    assignee: '',
    status: 'pending',
    dueDate: ''
  };
  
  // Dummy data for assignees dropdown
  const assignees = [
    { id: 1, name: 'John Doe' },
    { id: 2, name: 'Jane Smith' },
    { id: 3, name: 'Alex Johnson' },
    { id: 4, name: 'Maria Garcia' },
    { id: 5, name: 'Robert Chen' }
  ];
  
  function handleSave() {
    dispatch('save', task);
  }
  
  function handleCancel() {
    dispatch('cancel');
  }
</script>

<div class="workflow-details">
  <div class="header">
    <h2>Workflow Task Details</h2>
  </div>
  
  <div class="form-container">
    <div class="form-group">
      <label for="task-title">Title</label>
      <input 
        type="text" 
        id="task-title" 
        bind:value={task.name} 
        placeholder="Enter task title"
      />
    </div>
    
    <div class="form-group">
      <label for="task-description">Description</label>
      <textarea 
        id="task-description" 
        bind:value={task.description} 
        placeholder="Enter task description"
        rows="4"
      ></textarea>
    </div>
    
    <div class="form-group">
      <label for="task-assignee">Assignee</label>
      <select id="task-assignee" bind:value={task.assignee}>
        <option value="">Select assignee</option>
        {#each assignees as assignee}
          <option value={assignee.id}>{assignee.name}</option>
        {/each}
      </select>
    </div>
    
    <div class="form-group">
      <label for="task-status">Status</label>
      <select id="task-status" bind:value={task.status}>
        <option value="pending">Pending</option>
        <option value="in-progress">In Progress</option>
        <option value="completed">Completed</option>
      </select>
    </div>
    
    <div class="form-group">
      <label for="task-due-date">Due Date</label>
      <input 
        type="date" 
        id="task-due-date" 
        bind:value={task.dueDate}
      />
    </div>
    
    <div class="actions">
      <button class="cancel-button" on:click={handleCancel}>Cancel</button>
      <button class="save-button" on:click={handleSave}>Save</button>
    </div>
  </div>
</div>

<style>
  .workflow-details {
    padding: 16px;
    background-color: var(--card-color);
    border-radius: 8px;
    box-shadow: 0 2px 8px rgba(0,0,0,0.2);
  }
  
  .header {
    margin-bottom: 24px;
  }
  
  .header h2 {
    font-size: 20px;
    margin: 0;
    color: var(--text-color);
  }
  
  .form-container {
    display: flex;
    flex-direction: column;
    gap: 16px;
  }
  
  .form-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  
  label {
    font-size: 14px;
    font-weight: 500;
    color: var(--text-light);
  }
  
  input, textarea, select {
    padding: 12px;
    border-radius: 6px;
    border: 1px solid var(--border-color, #444);
    background-color: var(--input-bg, rgba(255, 255, 255, 0.05));
    color: var(--text-color);
    font-size: 16px;
    transition: border-color 0.2s;
  }
  
  input:focus, textarea:focus, select:focus {
    outline: none;
    border-color: var(--primary-color, #2196F3);
  }
  
  textarea {
    resize: vertical;
    min-height: 100px;
  }
  
  .actions {
    display: flex;
    justify-content: flex-end;
    gap: 16px;
    margin-top: 16px;
  }
  
  button {
    padding: 10px 20px;
    border-radius: 6px;
    font-size: 16px;
    font-weight: 500;
    cursor: pointer;
    transition: all 0.2s;
  }
  
  .cancel-button {
    background-color: transparent;
    border: 1px solid var(--border-color, #444);
    color: var(--text-light);
  }
  
  .cancel-button:hover {
    background-color: rgba(255, 255, 255, 0.05);
  }
  
  .save-button {
    background-color: var(--primary-color, #2196F3);
    border: none;
    color: white;
  }
  
  .save-button:hover {
    background-color: var(--primary-color-dark, #1976D2);
  }
</style> 