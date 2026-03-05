import 'package:flutter/material.dart';

class Task {
  String title;
  bool completed;

  Task(this.title, this.completed);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [];
  String? userInput;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            "TO DO",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),

      backgroundColor: const Color.fromARGB(255, 171, 143, 250),

      body: tasks.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/todo.png", width: 300, height: 300),
                  Text(
                    "Tasks you add will appear here...",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 7),
                ],
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
                          color: Colors.deepPurple,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
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
                                  color: Colors.white,
                                ),
                                onTap: () {
                                  setState(() {
                                    tasks[index].completed =
                                        !tasks[index].completed;
                                  });
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
                                    decoration: tasks[index].completed
                                        ? TextDecoration.lineThrough
                                        : null,
                                    decorationColor: Colors.grey,
                                    decorationThickness: 2,
                                    color: tasks[index].completed
                                        ? Colors.grey[400]
                                        : Colors.white,
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
                                  color: Colors.white,
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
        backgroundColor: Colors.deepPurple,
        child: Icon(
          Icons.add,
          color: Colors.white,
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
          backgroundColor: const Color.fromARGB(255, 197, 176, 255),
          title: Text(
            "Add Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  onChanged: (String value) {
                    userInput = value;
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
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      userInput = null;
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (userInput != null && userInput!.isNotEmpty) {
                        setState(() {
                          tasks.add(Task(userInput!, false));
                          userInput = null;
                        });
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
    final controller = TextEditingController(text: tasks[index].title);
    userInput = tasks[index].title;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 197, 176, 255),
          title: Text(
            "Edit Task",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  autofocus: true,
                  controller: controller,
                  onChanged: (String value) {
                    userInput = value;
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
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      userInput = null;
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (userInput != null && userInput!.isNotEmpty) {
                        setState(() {
                          tasks[index].title = userInput!;
                        });
                      }
                      Navigator.of(context).pop();
                      userInput = null;
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
          backgroundColor: const Color.fromARGB(255, 197, 176, 255),
          title: Text(
            "Are you sure you want to delete this task ?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple,
                  ),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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
