import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

export const useSuperAdminStore = defineStore('superAdmin', {
  state: () => ({
    superAdmin: null,
    token: '',
    superAdmins: [],
  }),
  actions: {
    async login(credentials: { email: string; password: string }) {
      try {
        const response = await axios.post('/api/v1/superadmin/auth/login', credentials);
        this.superAdmin = response.data.user;
        this.token = response.data.user.tokens.token;
      } catch (error) {
        throw new Error('Login failed');
      }
    },
    async createSuperAdmin(superAdminData: { email: string; password: string }) {
      await axios.post('/api/v1/superadmin/auth/create', superAdminData);
      await this.fetchSuperAdmins();
    },
    async fetchSuperAdmins() {
      const response = await axios.get('/api/v1/superadmin/auth/get');
      this.superAdmins = response.data.superAdmins;
    },
    logout() {
      this.superAdmin = null;
      this.token = '';
    },
  },
});
