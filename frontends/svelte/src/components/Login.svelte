<script>
  import { createEventDispatcher } from 'svelte';
  const dispatch = createEventDispatcher();

  let username = '';
  let password = '';
  let error = '';
  let loading = false;

  const handleLogin = async () => {
    if (!username || !password) {
      error = 'Please enter both username and password';
      return;
    }

    loading = true;
    error = '';

    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000));

    // Check credentials
    if (username === 'summit' && password === 'hackathon2025') {
      dispatch('loginSuccess');
    } else {
      error = 'Invalid credentials';
    }

    loading = false;
  };
</script>

<div class="login-container">
  <div class="login-box">
    <h2>FieldTwin Mobile</h2>
    <p class="subtitle">Sign in to continue</p>

    <form on:submit|preventDefault={handleLogin}>
      <div class="form-group">
        <label for="username">Username</label>
        <input
          type="text"
          id="username"
          bind:value={username}
          placeholder="Enter your username"
          disabled={loading}
        />
      </div>

      <div class="form-group">
        <label for="password">Password</label>
        <input
          type="password"
          id="password"
          bind:value={password}
          placeholder="Enter your password"
          disabled={loading}
        />
      </div>

      {#if error}
        <div class="error-message">
          {error}
        </div>
      {/if}

      <button type="submit" disabled={loading}>
        {#if loading}
          <span class="spinner"></span>
        {:else}
          Sign In
        {/if}
      </button>
    </form>
  </div>
</div>

<style>
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    min-height: 100vh;
    background-color: var(--background-color);
    padding: 1rem;
  }

  .login-box {
    background: rgb(50, 53, 56);
    padding: 2rem;
    border-radius: 8px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.2);
    width: 100%;
    max-width: 400px;
  }

  h2 {
    text-align: center;
    color: white;
    margin-bottom: 0.5rem;
  }

  .subtitle {
    text-align: center;
    color: #aaa;
    margin-bottom: 2rem;
  }

  .form-group {
    margin-bottom: 1.5rem;
  }

  label {
    display: block;
    margin-bottom: 0.5rem;
    color: #ddd;
    font-weight: 500;
  }

  input {
    width: 100%;
    padding: 0.75rem;
    border: 1px solid #444;
    border-radius: 4px;
    font-size: 1rem;
    background-color: #333;
    color: white;
  }

  input:focus {
    outline: none;
    border-color: #666;
  }

  button {
    width: 100%;
    padding: 0.75rem;
    background-color: #666;
    color: white;
    border: none;
    border-radius: 4px;
    font-size: 1rem;
    cursor: pointer;
    display: flex;
    justify-content: center;
    align-items: center;
  }

  button:hover {
    background-color: #777;
  }

  button:disabled {
    opacity: 0.7;
    cursor: not-allowed;
  }

  .error-message {
    color: #ff6b6b;
    margin-bottom: 1rem;
    padding: 0.5rem;
    background-color: rgba(255, 107, 107, 0.1);
    border-radius: 4px;
    text-align: center;
  }

  .spinner {
    width: 20px;
    height: 20px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-radius: 50%;
    border-top-color: white;
    animation: spin 1s ease-in-out infinite;
  }

  @keyframes spin {
    to {
      transform: rotate(360deg);
    }
  }
</style> 