import { createRouter, createWebHistory } from "vue-router";
import Home from "../views/HomeView.vue";

const routes = [
  {
    path: "/",
    name: "home",
    component: Home,
  },
  {
    path: "/statistics/:id",
    name: "statistics",
    component: () => import("../views/StatisticsView.vue"),
  },
  {
    path: "/:pathMatch(.*)*",
    name: "not-found",
    component: () => import("../views/NotFoundView.vue"),
  },
];

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
});

export default router;
