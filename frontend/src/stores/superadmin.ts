import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

export const useSuperAdminStore = defineStore('superadmin', {
  state: () => ({
    superAdmins: [],
  }),
  actions: {
    async fetchSuperAdmins() {
      const response = await axios.get('/api/v1/superadmin/get');
      this.superAdmins = response.data.superAdmins;
    },
    async createSuperAdmin(superAdminData: any) {
      await axios.post('/api/v1/superadmin/create', superAdminData);
      this.fetchSuperAdmins();
    },
  },
});
