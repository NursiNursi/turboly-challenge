<script setup>
import { ref, onMounted, computed, watch } from "vue";
import SearchForm from "./SearchForm.vue";
import SortButtons from "./SortButtons.vue";
import List from "./List.vue";

const todos = ref([]);
const name = ref("");
const searchFilter = ref("");
const sort = ref("");
const showCreate = ref(false);

const descriptionSort = ref(false);
const dateSort = ref(false);
const prioritySort = ref(false);
const completionSort = ref(false);

const priorityLevels = {
  low: 3,
  middle: 2,
  high: 1,
};

const input_content = ref("");
const input_dueDate = ref("");
const input_priority = ref(null);

const loadFromLocalStorage = () => {
  name.value = localStorage.getItem("name") || "";
  todos.value = JSON.parse(localStorage.getItem("todos")) || [];
};

const saveToLocalStorage = () => {
  localStorage.setItem("todos", JSON.stringify(todos.value));
};

watch(name, saveToLocalStorage);
watch(todos, saveToLocalStorage, { deep: true });

const filteredItems = computed(() => {
  let items = [...todos.value];

  if (searchFilter.value !== "") {
    items = items.filter((item) =>
      item.content.toLowerCase().includes(searchFilter.value)
    );
  }

  switch (sort.value) {
    case "content":
      items.sort(
        (a, b) =>
          a.content.localeCompare(b.content) * (descriptionSort.value ? 1 : -1)
      );
      break;
    case "date":
      items.sort(
        (a, b) =>
          (new Date(a.dueDate) - new Date(b.dueDate)) *
          (dateSort.value ? 1 : -1)
      );
      break;
    case "priority":
      items.sort(
        (a, b) =>
          (priorityLevels[a.priority] - priorityLevels[b.priority]) *
          (prioritySort.value ? 1 : -1)
      );
      break;
    case "completion":
      items.sort((a, b) => (a.done - b.done) * (completionSort.value ? 1 : -1));
      break;
    default:
  }
  return items;
});

const addTodo = () => {
  if (!input_content.value.trim() || input_priority.value === null) return;

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

const removeTodo = (todo) => {
  todos.value = todos.value.filter((t) => t !== todo);
};

const handleSearch = (search) => {
  searchFilter.value = search;
};

const handleSort = (type) => {
  // console.log(descriptionSort);
  if (sort.value === type) {
    switch (type) {
      case "content":
        descriptionSort.value = !descriptionSort.value;
        break;
      case "date":
        dateSort.value = !dateSort.value;
        break;
      case "priority":
        prioritySort.value = !prioritySort.value;
        break;
      case "completion":
        completionSort.value = !completionSort.value;
        break;
    }
  } else {
    sort.value = type;
    descriptionSort.value =
      dateSort.value =
      prioritySort.value =
      completionSort.value =
        false;
    switch (type) {
      case "content":
        descriptionSort.value = true;
        break;
      case "date":
        dateSort.value = true;
        break;
      case "priority":
        prioritySort.value = true;
        break;
      case "completion":
        completionSort.value = true;
        break;
    }
  }
};

onMounted(loadFromLocalStorage);
</script>
<template>
  <main class="app">
    <section class="todo-list">
      <h1 class="display-5 fw-bold mb-4">TODO LIST</h1>
      <div class="d-flex justify-content-between head-row">
        <SearchForm @search="handleSearch" />
        <SortButtons
          @sort="handleSort"
          :descriptionSort="descriptionSort"
          :dateSort="dateSort"
          :prioritySort="prioritySort"
          :completionSort="completionSort"
        />
      </div>

      <List :filteredItems="filteredItems" @remove="removeTodo" />
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
          <label v-for="(level, key) in priorityLevels" :key="key">
            <input
              type="radio"
              name="priority"
              :id="'priority' + key"
              :value="key"
              v-model="input_priority"
            />
            <span class="bubble" :class="key"></span>
            <div>{{ key }}</div>
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
