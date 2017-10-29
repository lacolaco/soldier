import axios from 'axios';
import JSZip from 'jszip';
import { saveAs } from 'file-saver';
import Vue from './main.es6';

/* eslint no-unused-vars: 0 */
const vm = new Vue({
  el: '#index',
  data: {
    template: {
      safeMath: undefined,
      token: undefined,
    },
    name: undefined,
    symbol: undefined,
    amount: undefined,
    decimals: undefined,
    rate: undefined,
  },
  methods: {
    toggleSidenav() {
      this.$refs.sidenav.toggle();
    },
    submit() {
      if (!this.name || !this.symbol || this.amount === undefined || this.decimals === undefined || this.rate === undefined) {
        this.$refs.error.open();
        return;
      }
      this.amount = Math.floor(this.amount);
      this.decimals = Math.floor(this.decimals);
      this.rate = Math.floor(this.rate);
      if (this.amount < 1 || this.decimals < 0 || this.decimals > 18 || this.rate < 1) {
        this.$refs.error.open();
        return;
      }
      const keys = ['name', 'symbol', 'amount', 'decimals', 'rate'];
      let token = this.template.token;
      for (let i = 0; i < keys.length; i++) {
        const key = keys[i];
        const regexp = new RegExp(`{{${key}}}(.*?)`, 'g');
        token = token.replace(regexp, this[key]);
      }
      const zip = new JSZip();
      zip.file('SafeMath.sol', this.template.safeMath);
      zip.file('Token.sol', token);
      zip.generateAsync({ type: 'blob' })
        .then((content) => {
          saveAs(content, 'solid.zip');
        })
        .catch((error) => {
          this.$refs.error.open();
          console.error(error);
        });
    },
    initialized() {
      return this.template.safeMath && this.template.token;
    },
  },
  mounted() {
    axios.get('/solidity/SafeMath.sol')
      .then((res) => {
        this.template.safeMath = res.data;
        return axios.get('/solidity/Token.sol');
      })
      .then((res) => {
        this.template.token = res.data;
      })
      .catch((error) => {
        this.$refs.error.open();
        console.error(error);
      });
  },
});
