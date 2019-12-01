<template>
  <div id="app">
    <Loading v-if="isLoading" />
    <LoginForm v-if="!isLogged" @logged="logged"/>
    <!--<RegisterForm />-->
    <div v-if="isLogged">
      <Navbar />
      <HomePage />
      <GradesPage ref="gradesRef"/>
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

import API from "./api.js";
import User from "./user.js";

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
    logged: async function() {
      this.isLogged = true;
      setTimeout(() => {
        console.log("after 1 sec");
        this.$refs.gradesRef.loadGrades()
      }, 1000);
    }
  },
  data: function() {
    return {
      isLoading: false,
      isLogged: false
    };
  }
};
</script>

<style>
</style>
