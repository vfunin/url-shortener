import { createApp } from "vue";
import App from "./App.vue";
import "./main.css";
import router from "./router";
import { plugin as VueTippy } from "vue-tippy";
import VueClipboard from "vue3-clipboard";
import "tippy.js/dist/tippy.css"; // optional for styling
import "tippy.js/themes/light.css";

const vm = createApp(App)
  .use(router)
  .use(VueClipboard, {
    autoSetContainer: true,
    appendToBody: true,
  })
  .use(VueTippy, {
    defaultProps: { theme: "light" },
  })
  .mount("#app");

export default vm;
