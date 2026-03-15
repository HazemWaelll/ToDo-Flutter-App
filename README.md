# To-Do List App

A simple and clean to-do list app built with Flutter.

## Features

- **Create tasks** with a title and description
- **Mark tasks as completed** with a checkbox
- **Delete tasks** with a cooldown to prevent accidental removal
- **Persistent storage** using Hive (tasks and settings survive app restarts)
- **Multiple themes** — Light, Dark, and Purple
- **Hidden drawer navigation** between Home and Settings pages

## Screenshots

<img src="assets/Screenshots/screenshot_1.png" alt="Screenshot 1" width="250" style="margin-right: 16px;"/>
<img src="assets/Screenshots/screenshot_2.png" alt="Screenshot 2" width="250" style="margin-right: 16px;"/>
<img src="assets/Screenshots/screenshot_3.png" alt="Screenshot 3" width="250"/>

## Getting Started

1. **Clone the repo**
   ```bash
   git clone <repo-url>
   cd todolist_app
   ```
2. **Install dependencies**
   ```bash
   flutter pub get
   ```
3. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart              # App entry point, theme definitions
└── pages/
    ├── hidden_drawer.dart # Drawer navigation setup
    ├── home_page.dart     # Task list (add, complete, delete)
    └── settings.dart      # Theme selection
```
