import { Module } from 'vuex';
import api from '@/utils/api';

interface EnrollmentState {
  enrollments: Array<any>;
  currentEnrollment: any;
}

const enrollment: Module<EnrollmentState, any> = {
  state: {
    enrollments: [],
    currentEnrollment: null,
  },
  mutations: {
    setEnrollments(state, enrollments) {
      state.enrollments = enrollments;
    },
    setCurrentEnrollment(state, enrollment) {
      state.currentEnrollment = enrollment;
    },
  },
  actions: {
    async fetchEnrollments({ commit }) {
      try {
        const response = await api.get('/institution/admin/enrollment/list');
        commit('setEnrollments', response.data.enrollments);
      } catch (error) {
        console.error('Failed to fetch enrollments', error);
      }
    },
    async fetchEnrollmentById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/enrollment/${id}`);
        commit('setCurrentEnrollment', response.data.enrollment);
      } catch (error) {
        console.error('Failed to fetch enrollment', error);
      }
    },
    async updateEnrollment({ dispatch }, enrollment) {
      try {
        await api.put(`/institution/admin/enrollment/update/${enrollment._id}`, enrollment);
        dispatch('fetchEnrollments');
      } catch (error) {
        console.error('Failed to update enrollment', error);
      }
    },
    async addEnrollment({ commit }, enrollment) {
      const response = await api.post('/institution/admin/enrollment/create', enrollment);
      commit('addEnrollment', response.data.enrollment);
    },
  },
  getters: {
    enrollments: state => state.enrollments,
    currentEnrollment: state => state.currentEnrollment,
  },
};

export default enrollment;
