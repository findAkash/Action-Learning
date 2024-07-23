import { createRouter, createWebHistory, RouteRecordRaw } from 'vue-router';
import store from '@/store';
import SuperAdminLogin from '@/views/SuperAdminLogin.vue';
import UserLogin from '@/views/UserLogin.vue';
import SuperAdminDashboard from '@/views/SuperAdminDashboard.vue';
import AdminDashboard from '@/views/AdminDashboard.vue';
import InstitutionDetail from '@/views/InstitutionDetail.vue';
import CreateInstitution from '@/views/CreateInstitution.vue';
import Profile from '@/views/Profile.vue';

const routes: Array<RouteRecordRaw> = [
  { path: '/', redirect: '/login' },
  { path: '/user-login', component: UserLogin },
  { path: '/login', component: SuperAdminLogin },
  {
    path: '/superadmin-dashboard',
    component: SuperAdminDashboard,
    meta: { requiresAuth: true },
  },
  {
    path: '/admin-dashboard',
    component: AdminDashboard,
    meta: { requiresAuth: true },
  },
  {
    path: '/institution/:id',
    component: InstitutionDetail,
    meta: { requiresAuth: true },
  },
  {
    path: '/create-institution',
    component: CreateInstitution,
    meta: { requiresAuth: true },
  },
  {
    path: '/profile',
    component: Profile,
    meta: { requiresAuth: true },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!store.state.token) {
      next('/login');
    } else {
      next();
    }
  } else {
    next();
  }
});

router.afterEach((to) => {
  if (to.path === '/login' || to.path === '/user-login') {
    store.commit('clearUserData');
    localStorage.clear();
  }
});

export default router;
