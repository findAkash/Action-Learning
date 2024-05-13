import { createRouter, createWebHistory } from 'vue-router'
import LoginView from '../views/LoginView.vue'

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes: [
    //   {
    //     path: '/',
    //     name: 'home',
    //     component: HomeView,
    //     meta: {
    //       requiresAuth: false
    //     }
    //   },
      {
        path: '/login',
        name: 'login',
        component: LoginView,
        meta: {
          requiresAuth: false
        }
      }
    ]
});

router.beforeEach((to: any, from: any, next: Function) => {
    if (to.matched.some((record: any) => record.meta.requiresAuth)) {
        if (!localStorage.getItem('token')) {
            next({
                path: '/login',
                query: { redirect: to.fullPath }
            })
        } else {
            next()
        }
    } else {
        next()
    }
});

export default router;