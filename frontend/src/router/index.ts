import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import SuperAdminLogin from '@/views/SuperAdminLogin.vue';
import UserLogin from '@/views/UserLogin.vue';
import SuperAdminDashboard from '@/views/SuperAdminDashboard.vue';
import AdminDashboard from '@/views/AdminDashboard.vue';
import InstitutionDetail from '@/views/InstitutionDetail.vue';

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/login' },
  { path: '/user-login', component: UserLogin },
  { path: '/login', component: SuperAdminLogin },
  { path: '/superadmin-dashboard', component: SuperAdminDashboard },
  { path: '/admin-dashboard', component: AdminDashboard },
  { path: '/institution/:id', component: InstitutionDetail },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

export default router;
