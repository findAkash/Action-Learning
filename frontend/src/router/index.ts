import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import UserLogin from '@/views/UserLogin.vue';
import UserManagement from '@/views/UserManagement.vue';
import SuperAdminManagement from '@/views/SuperAdminManagement.vue';
import StudentManagement from '@/views/StudentManagement.vue';
import TeacherManagement from '@/views/TeacherManagement.vue';
import AdminManagement from '@/views/AdminManagement.vue';

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'UserLogin',
    component: UserLogin,
  },
  {
    path: '/user-management',
    name: 'UserManagement',
    component: UserManagement,
  },
  {
    path: '/superadmin-management',
    name: 'SuperAdminManagement',
    component: SuperAdminManagement,
  },
  {
    path: '/student-management',
    name: 'StudentManagement',
    component: StudentManagement,
  },
  {
    path: '/teacher-management',
    name: 'TeacherManagement',
    component: TeacherManagement,
  },
  {
    path: '/admin-management',
    name: 'AdminManagement',
    component: AdminManagement,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
