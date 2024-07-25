import { Module } from 'vuex';
import api from '@/utils/api';

interface TeacherState {
  teachers: Array<any>;
  currentTeacher: any;
}

const teacher: Module<TeacherState, any> = {
  state: {
    teachers: [],
    currentTeacher: null,
  },
  mutations: {
    setTeachers(state, teachers) {
      state.teachers = teachers;
    },
    setCurrentTeacher(state, teacher) {
      state.currentTeacher = teacher;
    },
  },
  actions: {
    async fetchTeachers({ commit }) {
      try {
        const response = await api.get('/institution/admin/teacher/list');
        commit('setTeachers', response.data.teachers);
      } catch (error) {
        console.error('Failed to fetch teachers', error);
      }
    },
    async fetchTeacherData({ commit }) {
      try {
        const response = await api.get('/institution/teacher', {
          headers: {
            Authorization: `Bearer ${this.state.token}`,
          },
        });
        commit('setCurrentTeacher', response.data.teacher);
      } catch (error) {
        console.error('Failed to fetch teacher data', error);
      }
    },
    async fetchTeacherById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/teacher/${id}`);
        commit('setCurrentTeacher', response.data.teacher);
      } catch (error) {
        console.error('Failed to fetch teacher', error);
      }
    },
    async updateTeacher({ dispatch }, teacher) {
      try {
        await api.put(`/institution/admin/teacher/update/${teacher._id}`, teacher);
        dispatch('fetchTeachers');
      } catch (error) {
        console.error('Failed to update teacher', error);
      }
    },
    async addTeacher({ commit }, teacher) {
      const response = await api.post('/institution/admin/teacher/create', teacher);
      commit('addTeacher', response.data.teacher);
    },
  },
  getters: {
    teachers: state => state.teachers,
    currentTeacher: state => state.currentTeacher,
  },
};

export default teacher;
