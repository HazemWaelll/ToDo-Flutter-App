import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Task {
  String title;
  String description;
  bool completed;

  Task(this.title, this.description, this.completed);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String? userInput;
  String? userDescription;
  late Box _tasksBox;

  @override
  void initState() {
    super.initState();
    _tasksBox = Hive.box('tasksBox');
    _loadTasks();
  }

  void _loadTasks() {
    final List titles = _tasksBox.get('titles', defaultValue: []);
    final List descriptions = _tasksBox.get('descriptions', defaultValue: []);
    final List completed = _tasksBox.get('completed', defaultValue: []);

    setState(() {
      tasks = [];
      for (int i = 0; i < titles.length; i++) {
        tasks.add(Task(titles[i], descriptions[i], completed[i]));
      }
    });
  }

  Future<void> _saveTasks() async {
    List<String> titles = [];
    List<String> descriptions = [];
    List<bool> completed = [];

    for (int i = 0; i < tasks.length; i++) {
      titles.add(tasks[i].title);
      descriptions.add(tasks[i].description);
      completed.add(tasks[i].completed);
    }

    _tasksBox.put('titles', titles);
    _tasksBox.put('descriptions', descriptions);
    _tasksBox.put('completed', completed);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: tasks.isEmpty
          ? Center(
              child: Text(
                "Tasks you add will appear here",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor,
                  fontSize: 20,
                ),
              ),
            )
          : ListView.builder(
              itemCount: tasks.length,
              padding: EdgeInsets.only(
                top: 26,
                bottom: 16,
                left: 16,
                right: 16,
              ),
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      tasks.removeAt(index);
                    });
                    _saveTasks();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: GestureDetector(
                      onTap: () {
                        editTask(index);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).shadowColor,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: GestureDetector(
                                child: Icon(
                                  tasks[index].completed
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: Theme.of(context).canvasColor,
                                ),
                                onTap: () {
                                  setState(() {
                                    tasks[index].completed =
                                        !tasks[index].completed;
                                  });
                                  _saveTasks();
                                },
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 8,
                                  right: 8,
                                ),
                                child: Text(
                                  tasks[index].title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: tasks[index].completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.grey,
                                    decorationThickness: 2,
                                    color: tasks[index].completed
                                        ? Colors.grey[400]
                                        : Theme.of(context).canvasColor,
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(-8, 0),
                              child: GestureDetector(
                                onTap: () {
                                  removeTask(index);
                                },
                                child: Icon(
                                  Icons.cancel_outlined,
                                  color: Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Theme.of(context).canvasColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> addTask() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Add Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  decoration: InputDecoration(
                    hintText: "Title",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    userInput = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  cursorColor: Theme.of(context).secondaryHeaderColor,
                  decoration: InputDecoration(
                    hintText: "Description (optional)",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ),
                  onChanged: (String value) {
                    userDescription = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      userInput = null;
                      userDescription = null;
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (userInput != null && userInput!.isNotEmpty) {
                        setState(() {
                          tasks.add(
                            Task(userInput!, userDescription ?? '', false),
                          );
                          userInput = null;
                          userDescription = null;
                        });
                        _saveTasks();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> editTask(int index) {
    final titleController = TextEditingController(text: tasks[index].title);
    final descriptionController = TextEditingController(
      text: tasks[index].description,
    );

    userInput = tasks[index].title;
    userDescription = tasks[index].description;

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Edit Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: titleController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Title",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (String value) {
                    userInput = value;
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.titleLarge?.color,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: "Description (optional)",
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  onChanged: (String value) {
                    userDescription = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      userInput = null;
                      userDescription = null;
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (userInput != null && userInput!.isNotEmpty) {
                        setState(() {
                          tasks[index].title = userInput!;
                          tasks[index].description = userDescription!;
                        });
                        _saveTasks();
                      }
                      Navigator.of(context).pop();
                      userInput = null;
                      userDescription = null;
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> removeTask(int index) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Are you sure you want to delete this task ?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).primaryColor,
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                      _saveTasks();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
