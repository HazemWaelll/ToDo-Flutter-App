import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist_app/pages/task_details.dart';

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
  late Box _tasksBox;
  bool hasPendingDelete = false;

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

  // Key to ensure that the snack bar message appear only in home page NO other pages
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
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
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        final updatedTask = await Navigator.push<Task>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TaskDetailsPage(
                              title: tasks[index].title,
                              description: tasks[index].description,
                              completed: tasks[index].completed,
                            ),
                          ),
                        );

                        if (updatedTask != null) {
                          setState(() {
                            tasks[index] = updatedTask;
                          });
                          _saveTasks();
                        }
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
                                  color: hasPendingDelete
                                      ? Colors.grey[400]
                                      : Theme.of(context).canvasColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newTask = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsPage(
                  title: '',
                  description: '',
                  completed: null,
                ),
              ),
            );

            if (newTask != null) {
              setState(() {
                tasks.add(newTask);
              });
              _saveTasks();
            }
          },

          backgroundColor: Theme.of(context).primaryColor,
          child: Icon(
            Icons.add,
            color: Theme.of(context).canvasColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // remove task
  Future<void> removeTask(int index) {
    if (hasPendingDelete) return Future.value();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            "Are you sure you want to remove this task ?",
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
                      final removedTask = tasks[index];
                      setState(() {
                        tasks.removeAt(index);
                        hasPendingDelete = true;
                      });
                      _saveTasks();
                      Navigator.of(context).pop();
                      final snackBarController = _messengerKey.currentState
                          ?.showSnackBar(snackBarMessage(index, removedTask));
                      snackBarController?.closed.then((_) {
                        if (mounted) {
                          setState(() {
                            hasPendingDelete = false;
                          });
                        }
                      });
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

  // snack bar message
  SnackBar snackBarMessage(int index, Task removedTask) {
    return SnackBar(
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
      content: Text(
        "Task has been deleted",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      action: SnackBarAction(
        label: 'Undo?',
        onPressed: () {
          setState(() {
            final safeIndex = index.clamp(0, tasks.length);
            tasks.insert(safeIndex, removedTask);
            hasPendingDelete = false;
          });
          _saveTasks();
        },
      ),
    );
  }
}
