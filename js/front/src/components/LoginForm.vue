<template>
  <div class="login-form" id="notlogged">
    <form action="#">
      <h2 class="text-center">Log in</h2>
      <div class="form-group">
        <input
          id="username"
          v-model="login"
          type="text"
          class="form-control"
          placeholder="Username"
          required="required"
        />
      </div>
      <div class="form-group">
        <input
          id="password"
          v-model="password"
          type="password"
          class="form-control"
          placeholder="Password"
          required="required"
        />
      </div>
      <div class="form-group">
        <button class="btn btn-primary btn-block font-weight-bold" @click="loginButton">Log in</button>
      </div>
    </form>
    <p class="text-center">
      <a href="/register.html">Create an Account</a>
    </p>
  </div>
</template>

<script>
import API from "../api.js";
import User from "../user.js";

export default {
  name: "LoginForm",
  methods: {
    loginButton: async function() {
      let logged = (await API.login(this.login, this.password));
      if(logged) {
        User.isLogged = true;
        let info = await API.userInfo();
        User.name = info.name;
        User.mail = info.mail;
        // call parent component
        this.$emit("logged");
      }
    }
  },
  data: function() {
    return {
      login: "",
      password: ""
    };
  }
};
</script>

<style scoped>
.login-form {
  width: 340px;
  margin: 50px auto;
}

.login-form form {
  margin-bottom: 15px;
  background: #f7f7f7;
  box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
  padding: 30px;
}

.login-form h2 {
  margin: 0 0 15px;
}
</style>