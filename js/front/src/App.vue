<template>
  <div id="app">
    <Loading v-if="isLoading" />
    <LoginForm v-if="!isLogged" @logged="logged" />
    <div class="container" v-show="isLogged">
      <Navbar @select="changePage" @logout="logout"/>
      <HomePage v-show="currentPage=='home'" />
      <GradesPage ref="gradesRef" v-show="currentPage=='grades'"  />
      <TimetablePage ref="tableRef" v-show="currentPage=='table'"  />
      <MapPage v-show="currentPage=='map'"/>
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
    TimetablePage,
    MapPage
  },
  methods: {
    changePage(page) {
      this.currentPage = page;
    },
    logged: async function() {
      this.isLogged = true;
      this.$refs.gradesRef.loadGrades();
      this.$refs.tableRef.loadTable();
    },
    logout: async function() {
      this.isLogged = false;
      await API.logout();
    }
  },
  data: function() {
    return {
      isLoading: false,
      isLogged: false,
      currentPage: "home",
    };
  }
};
</script>

<style>
</style>
