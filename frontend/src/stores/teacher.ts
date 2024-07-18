import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

export const useTeacherStore = defineStore('teacher', {
  state: () => ({
    teachers: [],
  }),
  actions: {
    async fetchTeachers() {
      const response = await axios.get('/api/v1/teachers');
      this.teachers = response.data.teachers;
    },
    async createTeacher(teacherData: any) {
      await axios.post('/api/v1/teachers/create', teacherData);
      this.fetchTeachers();
    },
  },
});
