import { createApp } from 'vue';
import App from './App.vue';
import router from './router';
import store from './store';
import './index.css';
import vuetify from './plugins/vuetify';
console.log('API Base URL:', process.env.VUE_APP_API_BASE_URL);

createApp(App).use(store).use(router).use(vuetify).mount('#app');
