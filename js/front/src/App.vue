<template>
  <div id="app">
    <Loading v-if="loading" @submit="submit" />
    <LoginForm v-if="!logged" />
    <!--<RegisterForm />-->
    <div v-if="logged">
      <Navbar />
      <HomePage />
      <GradesPage />
      <TimetablePage />
    </div>
  </div>
</template>

<script>
import Loading from "./components/Loading.vue";
import LoginForm from "./components/LoginForm.vue";
import Navbar from "./components/Navbar.vue";
import RegisterForm from "./components/RegisterForm.vue";
import HomePage from "./components/HomePage.vue";
import GradesPage from "./components/GradesPage.vue";
import TimetablePage from "./components/TimetablePage.vue";
import MapPage from "./components/MapPage.vue";

import api from "./api.js";

export default {
  name: "app",
  components: {
    Loading,
    LoginForm,
    Navbar,
    RegisterForm,
    HomePage,
    GradesPage,
    TimetablePage
  },
  methods: {
    submit: async function(login, password) {
      loading = true;

      loading = false;
    }
  },
  data: function() {
    return {
      loading: false,
      logged: false
    };
  }
};
</script>

<style>
</style>
