import { Module } from 'vuex';
import api from '@/utils/api';

interface StudentState {
  students: Array<any>;
  currentStudent: any;
}

const student: Module<StudentState, any> = {
  state: {
    students: [],
    currentStudent: null,
  },
  mutations: {
    setStudents(state, students) {
      state.students = students;
    },
    setCurrentStudent(state, student) {
      state.currentStudent = student;
    },
  },
  actions: {
    async fetchStudents({ commit }) {
      try {
        const response = await api.get('/institution/admin/student/list');
        commit('setStudents', response.data.students);
      } catch (error) {
        console.error('Failed to fetch students', error);
      }
    },
    async fetchStudentById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/student/${id}`);
        commit('setCurrentStudent', response.data.student);
      } catch (error) {
        console.error('Failed to fetch student', error);
      }
    },
    async updateStudent({ dispatch }, student) {
      try {
        await api.put(`/institution/admin/student/update/${student._id}`, student);
        dispatch('fetchStudents');
      } catch (error) {
        console.error('Failed to update student', error);
      }
    },
    async addStudent({ commit }, student) {
      const response = await api.post('/institution/admin/students/create', student);
      commit('addStudent', response.data.student);
    },
  },
  getters: {
    students: state => state.students,
    currentStudent: state => state.currentStudent,
  },
};

export default student;
