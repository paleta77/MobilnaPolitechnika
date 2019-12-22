<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light mb-1">
    <a class="navbar-brand">PŁ</a>
    <button
      class="navbar-toggler"
      type="button"
      data-toggle="collapse"
      data-target="#navbarSupportedContent"
      aria-controls="navbarSupportedContent"
      aria-expanded="false"
      aria-label="Toggle navigation"
    >
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav mr-auto">
        <li class="nav-item">
          <a class="nav-link" href="#" @click="click('home')">Home</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" @click="click('grades')">Grades</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" @click="click('table')">Timetable</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#" @click="click">Map</a>
        </li>
      </ul>
      <form class="form-inline my-2 my-lg-0">
        <!--<input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
        <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>-->
        <button class="btn btn-primary ml-5 my-2 my-sm-0" @click="logout">Logout</button>
      </form>
    </div>
  </nav>
</template>

<script>
export default {
  name: "Navbar",
  methods: {
    click: function(page) {
      console.log("click pressed! " +page);
      this.$emit('select', page);
    },
    logout: function() {
      console.log("logout pressed!");
    }
  }
};
</script>

<style scoped>
</style>