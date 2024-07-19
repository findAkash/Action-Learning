import axios from 'axios';

const instance = axios.create({
  baseURL: 'http://localhost:8000',  // Adjust the baseURL to your backend API
  timeout: 5000,  // Set a longer timeout duration (e.g., 5 seconds)
});

export default instance;
