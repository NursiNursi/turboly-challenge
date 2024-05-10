<script setup>
import { useRouter } from "vue-router";

const router = useRouter();

const goTodo = () => {
  router.push("/todo");
};
</script>

<template>
  <div class="d-flex align-items-center justify-content-center vh-100">
    <div class="col-md-3">
      <div>
        <div>
          <h1>Welcome !</h1>
          <hr />
        </div>
        <form>
          <div class="form-group">
            <label>Email</label>
            <input type="text" class="form-control" />
          </div>
          <div class="form-group">
            <label>Password</label>
            <input type="password" class="form-control" />
          </div>

          <div class="my-4 d-grid">
            <button @click="goTodo" class="btn btn-primary">Login</button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
