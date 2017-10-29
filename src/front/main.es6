import Vue from 'vue';
import VueMaterial from 'vue-material';

Vue.use(VueMaterial);
Vue.material.registerTheme('default', {
  primary: 'light-blue',
  accent: 'pink',
  warn: 'red',
  background: 'white',
});

export default Vue;
