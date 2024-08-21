import { Module } from 'vuex';
import api from '@/utils/api';

interface CourseState {
  courses: Array<any>;
  currentCourse: any;
}

const course: Module<CourseState, any> = {
  state: {
    courses: [],
    currentCourse: null,
  },
  mutations: {
    setCourses(state, courses) {
      state.courses = courses;
    },
    setCurrentCourse(state, course) {
      state.currentCourse = course;
    },
  },
  actions: {
    async fetchCourses({ commit }) {
      try {
        const response = await api.get('/institution/admin/course/list');
        commit('setCourses', response.data.courses);
      } catch (error) {
        console.error('Failed to fetch courses', error);
      }
    },
    async fetchCourseById({ commit }, id) {
      try {
        const response = await api.get(`/institution/admin/course/${id}`);
        commit('setCurrentCourse', response.data.course);
      } catch (error) {
        console.error('Failed to fetch course', error);
      }
    },
    async updateCourse({ dispatch }, course) {
      try {
        await api.put(`/institution/admin/course/update/${course._id}`, course);
        dispatch('fetchCourses');
      } catch (error) {
        console.error('Failed to update course', error);
      }
    },
    async addCourse({ commit }, course) {
      const response = await api.post('/institution/admin/course/create', course);
      commit('addCourse', response.data.course);
    },
  },
  getters: {
    courses: state => state.courses,
    currentCourse: state => state.currentCourse,
  },
};

export default course;
