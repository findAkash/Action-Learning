import { defineStore } from 'pinia';
import axios from '@/plugins/axios';

export const useStudentStore = defineStore('student', {
  state: () => ({
    students: [],
  }),
  actions: {
    async fetchStudents() {
      const response = await axios.get('/api/v1/students');
      this.students = response.data.students;
    },
    async createStudent(studentData: any) {
      await axios.post('/api/v1/students/create', studentData);
      this.fetchStudents();
    },
  },
});
