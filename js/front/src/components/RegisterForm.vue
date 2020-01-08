<template>
  <div class="login-form" id="notlogged">
    <form action="#">
      <h2 class="text-center">Register</h2>
      <div class="form-group">
        <input
          id="username"
          type="text"
          class="form-control"
          placeholder="Username"
          required="required"
        />
      </div>
      <div class="form-group">
        <input id="mail" type="text" class="form-control" placeholder="Mail" required="required" />
      </div>
      <div class="form-group">
        <input
          id="password"
          type="password"
          class="form-control"
          placeholder="Password"
          required="required"
        />
      </div>
      <div class="form-group">
        <button class="btn btn-primary btn-block font-weight-bold" @click="register">Register</button>
      </div>
    </form>
    <p class="text-center">
      <a href="/index.html">Already register? Login :)</a>
    </p>
  </div>
</template>

<script>
export default {
  name: "RegisterForm",
  methods: {
    register: function() {
      console.log("Please register!");
      // TODO: Implement!
    }
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