import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

export const useAdminStore = defineStore('admin', {
  state: () => ({
    admins: [],
  }),
  actions: {
    async fetchAdmins() {
      const response = await axios.get('/api/v1/admins');
      this.admins = response.data.admins;
    },
    async createAdmin(adminData: any) {
      await axios.post('/api/v1/admins/create', adminData);
      this.fetchAdmins();
    },
  },
});
