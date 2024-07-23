import { createStore } from 'vuex';
import api from '@/utils/api';

export default createStore({
  state: {
    user: null,
    token: localStorage.getItem('token') || null,
    institutions: [],
  },
  mutations: {
    setUser(state, user) {
      state.user = user;
    },
    setToken(state, token) {
      state.token = token;
      localStorage.setItem('token', token);
    },
    clearUserData(state) {
      state.user = null;
      state.token = null;
      state.institutions = [];
      localStorage.setItem('token', '');
    },
    setInstitutions(state, institutions) {
      state.institutions = institutions;
    },
  },
  actions: {
    async fetchInstitutions({ commit }) {
      try {
        console.log(`Fetching institutions with token: ${this.state.token}`);
        const response = await api.get('/superadmin/institution/get', {
          headers: {
            Authorization: `Bearer ${this.state.token}`,
          },
        });
        commit('setInstitutions', response.data.institutions);
      } catch (error) {
        console.error('Failed to fetch institutions', error);
      }
    },
  },
  modules: {},
});
