import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import UserLogin from '@/views/UserLogin.vue';
import SuperAdminLogin from '@/views/SuperAdminLogin.vue';
import AdminDashboard from '@/views/AdminDashboard.vue';
import SuperAdminDashboard from '@/views/SuperAdminDashboard.vue';
import TeacherDashboard from '@/views/TeacherDashboard.vue';
import StudentDashboard from '@/views/StudentDashboard.vue';
import UserList from '@/views/UserList.vue';
import InstitutionList from '@/views/InstitutionList.vue';

const routes: Array<RouteRecordRaw> = [
  {
    path: '/',
    name: 'UserLogin',
    component: UserLogin,
  },
  {
    path: '/superadmin-login',
    name: 'SuperAdminLogin',
    component: SuperAdminLogin,
  },
  {
    path: '/admin-dashboard',
    name: 'AdminDashboard',
    component: AdminDashboard,
  },
  {
    path: '/superadmin-dashboard',
    name: 'SuperAdminDashboard',
    component: SuperAdminDashboard,
    children: [
      {
        path: 'users',
        name: 'UserList',
        component: UserList,
      },
      {
        path: 'institutions',
        name: 'InstitutionList',
        component: InstitutionList,
      },
    ],
  },
  {
    path: '/teacher-dashboard',
    name: 'TeacherDashboard',
    component: TeacherDashboard,
  },
  {
    path: '/student-dashboard',
    name: 'StudentDashboard',
    component: StudentDashboard,
  },
];

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes,
});

export default router;
