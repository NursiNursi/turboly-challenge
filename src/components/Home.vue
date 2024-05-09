<script setup>
import { ref, onMounted, computed, watch } from "vue";
import SearchForm from "./SearchForm.vue";

const todos = ref([]);
const name = ref("");
const searchFilter = ref("");
const sort = ref("");
const showCreate = ref(false);

const input_content = ref("");
const input_dueDate = ref("");
const input_priority = ref(null);

watch(name, (newVal) => {
  localStorage.setItem("name", newVal);
});

watch(
  todos,
  (newVal) => {
    localStorage.setItem("todos", JSON.stringify(newVal));
  },
  {
    deep: true,
  }
);

const filteredItems = computed(() => {
  let items = todos.value;

  if (searchFilter.value !== "") {
    items = items.filter((item) =>
      item.content.toLowerCase().includes(searchFilter.value)
    );
  }

  switch (sort.value) {
    case "content":
      todos.value.sort((a, b) => {
        return a.content.localeCompare(b.content);
      });
      break;
    case "date":
      todos.value.sort((a, b) => {
        const dateA = new Date(a.dueDate);
        const dateB = new Date(b.dueDate);

        return dateA - dateB;
      });
      break;
    case "priority":
      todos.value.sort((a, b) => {
        const priorityOrder = { high: 1, middle: 2, low: 3 };
        const priorityA = priorityOrder[a.priority];
        const priorityB = priorityOrder[b.priority];

        return priorityA - priorityB;
      });
      break;
    default:
  }
  return items;
});

const addTodo = () => {
  if (input_content.value.trim() === "" || input_priority.value === null) {
    return;
  }

  todos.value.push({
    content: input_content.value,
    dueDate: input_dueDate.value,
    priority: input_priority.value,
    done: false,
    editable: false,
    createdAt: new Date().getTime(),
  });

  showCreate.value = false;
};

const handleSearch = (search) => {
  searchFilter.value = search;
};

const removeTodo = (todo) => {
  todos.value = todos.value.filter((t) => t !== todo);
};

onMounted(() => {
  name.value = localStorage.getItem("name") || "";
  todos.value = JSON.parse(localStorage.getItem("todos")) || [];
});
</script>

<template>
  <main class="app">
    <section class="todo-list">
      <h1 class="display-5 fw-bold text-center mb-4">TODO LIST</h1>
      <div class="d-flex justify-content-between">
        <SearchForm @search="handleSearch" />
        <div class="sort-by">
          <button
            @click="sort = 'content'"
            type="button"
            class="btn btn-secondary"
          >
            Sort by Content
          </button>
          <button
            @click="sort = 'date'"
            type="button"
            class="btn btn-secondary"
          >
            Sort by Date
          </button>
          <button
            @click="sort = 'priority'"
            type="button"
            class="btn btn-secondary"
          >
            Sort by Priority
          </button>
        </div>
      </div>
      <div class="list" id="todo-list">
        <div
          v-for="todo in filteredItems"
          :class="`todo-item ${todo.done && 'done'}`"
        >
          <label>
            <input type="checkbox" v-model="todo.done" />
            <span
              :class="`bubble ${
                todo.priority == 'low'
                  ? 'low'
                  : todo.priority == 'middle'
                  ? 'middle'
                  : 'high'
              }`"
            ></span>
          </label>

          <div class="todo-content">
            <input type="text" v-model="todo.content" />
            <input disabled type="text" v-model="todo.dueDate" />
          </div>

          <div class="actions">
            <button class="delete" @click="removeTodo(todo)">Delete</button>
          </div>
        </div>
      </div>
    </section>

    <section v-if="showCreate" class="create-todo">
      <form id="new-todo-form" @submit.prevent="addTodo">
        <h4>What's on your todo list?</h4>
        <input
          type="text"
          name="content"
          id="content"
          placeholder="e.g. make a video"
          v-model="input_content"
        />

        <h4>Due Dates</h4>
        <input
          type="date"
          name="content"
          id="content"
          placeholder="Enter Due Date"
          v-model="input_dueDate"
        />

        <h4>Priorities</h4>
        <div class="options">
          <label>
            <input
              type="radio"
              name="priority"
              id="priority1"
              value="low"
              v-model="input_priority"
            />
            <span class="bubble low"></span>
            <div>Low</div>
          </label>

          <label>
            <input
              type="radio"
              name="priority"
              id="priority2"
              value="middle"
              v-model="input_priority"
            />
            <span class="bubble middle"></span>
            <div>Middle</div>
          </label>

          <label>
            <input
              type="radio"
              name="priority"
              id="priority2"
              value="high"
              v-model="input_priority"
            />
            <span class="bubble high"></span>
            <div>High</div>
          </label>
        </div>

        <input type="submit" value="Add todo" />
      </form>
    </section>
    <section v-if="!showCreate">
      <button class="create-new-todo" @click="showCreate = !showCreate">
        Add new todo
      </button>
    </section>
  </main>
</template>
