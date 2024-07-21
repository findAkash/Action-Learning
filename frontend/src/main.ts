import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';
import './index.css'; // Ensure this includes TailwindCSS styles

console.log('API Base URL:', process.env.VUE_APP_API_BASE_URL);

createApp(App).use(store).use(router).mount('#app');
