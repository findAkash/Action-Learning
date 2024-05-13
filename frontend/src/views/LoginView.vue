<template>
    <div class="login-container">
      <div class="login-form">
        <h2>Login</h2>
        <form @submit.prevent="login">
          <input type="text" placeholder="Username" v-model="username" required>
          <input type="password" placeholder="Password" v-model="password" required>
          <button type="submit">Login</button>
        </form>
      </div>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        username: '',
        password: ''
      };
    },
    methods: {
      login() {
        // Perform login logic here
        console.log('Logging in with:', this.username, this.password);
        // Example: You can send login request to the server
      }
    }
  };
  </script>
  
  <style scoped>
  .login-container {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
    width: 100vw;
    background-color: #121212; /* Dark background color */
    color: #fff; /* Text color */
  }
  
  .login-form {
    width: 300px;
    padding: 20px;
    background-color: #333; /* Darker form background color */
    border-radius: 8px;
  }
  
  input[type="text"],
  input[type="password"],
  button {
    display: block;
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border: none;
    background-color: #444; /* Darker input background color */
    color: #fff; /* Input text color */
    border-radius: 4px;
  }
  
  button {
    background-color: #007bff; /* Blue login button color */
    cursor: pointer;
  }
  
  button:hover {
    background-color: #0056b3; /* Darker blue hover color */
  }
  
  h2 {
    text-align: center;
  }
  </style>
  