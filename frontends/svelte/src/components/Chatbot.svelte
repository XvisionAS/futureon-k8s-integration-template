<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();
  
  let messages = [
    { id: 1, text: 'Hello! How can I help you today?', sender: 'bot' },
    { id: 2, text: 'I need help with my project', sender: 'user' },
    { id: 3, text: 'Of course! What specific aspect of your project would you like assistance with?', sender: 'bot' }
  ];
  
  let newMessage = '';
  
  function handleSend() {
    if (newMessage.trim()) {
      messages = [...messages, { 
        id: messages.length + 1, 
        text: newMessage, 
        sender: 'user' 
      }];
      newMessage = '';
      
      // Simulate bot response
      setTimeout(() => {
        messages = [...messages, { 
          id: messages.length + 1, 
          text: 'I understand. Let me help you with that.', 
          sender: 'bot' 
        }];
      }, 1000);
    }
  }
  
  function handleKeyPress(event) {
    if (event.key === 'Enter' && !event.shiftKey) {
      event.preventDefault();
      handleSend();
    }
  }

  function handleBack() {
    dispatch('back');
  }
</script>

<div class="chatbot-view">
  <div class="header">
    <button class="back-button" on:click={handleBack}>
      <svg viewBox="0 0 24 24" width="24" height="24">
        <path fill="currentColor" d="M20,11V13H8L13.5,18.5L12.08,19.92L4.16,12L12.08,4.08L13.5,5.5L8,11H20Z" />
      </svg>
    </button>
    <h1>AI Assistant</h1>
  </div>

  <div class="chat-container">
    <div class="messages">
      {#each messages as message}
        <div class="message {message.sender}">
          <div class="message-content">
            {message.text}
          </div>
        </div>
      {/each}
    </div>
    
    <div class="input-container">
      <input
        type="text"
        bind:value={newMessage}
        placeholder="Type your message..."
        on:keypress={handleKeyPress}
      />
      <button on:click={handleSend} class="send-button">
        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <line x1="22" y1="2" x2="11" y2="13"></line>
          <polygon points="22 2 15 22 11 13 2 9 22 2"></polygon>
        </svg>
      </button>
    </div>
  </div>
</div>

<style>
  .chatbot-view {
    padding: 16px;
    max-width: 800px;
    margin: 0 auto;
    height: 100%;
    display: flex;
    flex-direction: column;
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
    color: #e2e8f0;
  }

  .chat-container {
    flex: 1;
    display: flex;
    flex-direction: column;
    background-color: #1a1a1a;
    border-radius: 8px;
    box-shadow: 0 2px 4px rgba(0,0,0,0.2);
    overflow: hidden;
  }

  .messages {
    flex: 1;
    overflow-y: auto;
    padding: 1rem;
    display: flex;
    flex-direction: column;
    gap: 0.5rem;
  }

  .message {
    max-width: 80%;
    padding: 0.75rem;
    border-radius: 1rem;
    margin-bottom: 0.5rem;
  }

  .message.user {
    align-self: flex-end;
    background-color: #2d3748;
    color: #e2e8f0;
    border-bottom-right-radius: 0.25rem;
  }

  .message.bot {
    align-self: flex-start;
    background-color: #2d3748;
    color: #e2e8f0;
    border-bottom-left-radius: 0.25rem;
  }

  .input-container {
    display: flex;
    padding: 1rem;
    gap: 0.5rem;
    background-color: #1a1a1a;
    border-top: 1px solid #2d3748;
  }

  input {
    flex: 1;
    padding: 0.75rem;
    border: 1px solid #2d3748;
    border-radius: 1.5rem;
    outline: none;
    background-color: #2d3748;
    color: #e2e8f0;
  }

  input::placeholder {
    color: #718096;
  }

  .send-button {
    background-color: #4a5568;
    color: white;
    border: none;
    border-radius: 50%;
    width: 2.5rem;
    height: 2.5rem;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: background-color 0.2s;
  }

  .send-button:hover {
    background-color: #2d3748;
  }

  .send-button svg {
    width: 1.25rem;
    height: 1.25rem;
  }

  /* Responsive adjustments */
  @media (max-width: 600px) {
    .chatbot-view {
      padding: 12px;
    }

    h1 {
      font-size: 20px;
    }

    .message {
      max-width: 85%;
    }

    .input-container {
      padding: 0.75rem;
    }

    input {
      padding: 0.5rem 0.75rem;
    }
  }

  @media (max-width: 400px) {
    .chatbot-view {
      padding: 8px;
    }

    .header {
      margin-bottom: 16px;
    }

    .message {
      max-width: 90%;
      padding: 0.5rem;
    }
  }
</style> 