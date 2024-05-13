
# Turboly Challenge

This Todo List app allows users to enter tasks along with due dates and priorities, enabling them to view and manage their tasks efficiently. Users can mark tasks as completed, sort tasks by various criteria, and access the application from any device with a responsive UI/UX design.


## Features

- Task Entry
- Task Management
- Sorting
- Adaptive Design


## Tech Stack

**Client:** VueJs, Vue Router, Bootstrap, Vanilla CSS

**Server:** Ruby on Rails 7, sqlite3 (migrating to postgresql)

## Installation

Follow these steps:

1. Clone the repository
```bash
  git clone https://github.com/NursiNursi/turboly-challenge.git
  cd turboly-challenge
```

2. Apply pending database migrations and start the rails server
```bash
  rails db:migrate
  rails s
```

3. Start the Vue app
```bash
  npm install
  npm run dev
```

## Demo

Vercel Demo Link: https://turboly-challenge.vercel.app/
