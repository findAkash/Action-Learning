import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

interface User {
  _id: string;
  email: string;
  // Add other user properties if needed
}

export const useUserStore = defineStore('user', {
  state: () => ({
    user: null as User | null,
    token: '',
    users: [] as User[],
  }),
  actions: {
    async login(credentials: { email: string; password: string }) {
      const response = await axios.post('/api/v1/institution/login', credentials);
      this.user = response.data.user;
      this.token = response.data.token;
    },
    logout() {
      this.user = null;
      this.token = '';
    },
    async fetchUsers() {
      const response = await axios.get('/api/v1/institution/user/list');
      this.users = response.data.users;
    },
    async createUser(userData: any) {
      await axios.post('/api/v1/institution/user/create', userData);
      this.fetchUsers();
    },
  },
});
