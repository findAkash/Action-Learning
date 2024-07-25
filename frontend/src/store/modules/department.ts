import { Module } from 'vuex';
import api from '@/utils/api';

interface DepartmentState {
  departments: Array<any>;
  currentDepartment: any;
}

const department: Module<DepartmentState, any> = {
  state: {
    departments: [],
    currentDepartment: null,
  },
  mutations: {
    setDepartments(state, departments) {
      state.departments = departments;
    },
    setCurrentDepartment(state, department) {
      state.currentDepartment = department;
    },
  },
  actions: {
    async fetchDepartments({ commit }) {
      try {
        const response = await api.get('/institution/admin/department/list');
        commit('setDepartments', response.data.departments);
      } catch (error) {
        console.error('Failed to fetch departments', error);
      }
    },
    async fetchDepartmentById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/department/${id}`);
        commit('setCurrentDepartment', response.data.department);
      } catch (error) {
        console.error('Failed to fetch department', error);
      }
    },
    async updateDepartment({ dispatch }, department) {
      try {
        await api.put(`/institution/admin/department/update/${department._id}`, department);
        dispatch('fetchDepartments');
      } catch (error) {
        console.error('Failed to update department', error);
      }
    },
    async addDepartment({ commit }, department) {
      const response = await api.post('/institution/admin/department/create', department);
      commit('addDepartment', response.data.department);
    },
  },
  getters: {
    departments: state => state.departments,
    currentDepartment: state => state.currentDepartment,
  },
};

export default department;
