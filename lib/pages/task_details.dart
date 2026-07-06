import 'package:flutter/material.dart';
import 'package:todolist_app/pages/home_page.dart';

class TaskDetailsPage extends StatefulWidget {
  final String title;
  final String? description;
  final bool? completed;

  const TaskDetailsPage({
    super.key,
    required this.title,
    required this.description,
    required this.completed,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  String? userTitle;
  String? userDescription;
  TextEditingController? titleController;
  TextEditingController? descriptionController;

  void _closeWithTask() {
    if (userTitle != null && userTitle!.isNotEmpty) {
      final task = Task(
        userTitle!,
        userDescription ?? '',
        widget.completed ?? false,
      );
      userTitle = null;
      userDescription = null;
      Navigator.of(context).pop(task);
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    userTitle = widget.title;
    userDescription = widget.description;
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    titleController!.dispose();
    descriptionController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        _closeWithTask();
        return false;
      },

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: BackButton(
            color: Theme.of(context).canvasColor,
            onPressed: _closeWithTask,
          ),

          // title
          title: Transform.translate(
            offset: Offset(-19, 0),
            child: TextField(
              autofocus: true,
              controller: titleController,
              textCapitalization: TextCapitalization.sentences,
              style: TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontWeight: FontWeight.bold,
                fontSize: 23,
              ),
              cursorColor: Theme.of(context).secondaryHeaderColor,
              decoration: InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 23,
                ),
                border: InputBorder.none,
              ),
              onChanged: (String value) {
                userTitle = value;
              },
            ),
          ),
        ),

        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 10),
          child: Column(
            children: [
              // description
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 26,
                style: TextStyle(
                  color: Theme.of(context).textTheme.titleLarge?.color,
                  fontSize: 18,
                ),
                cursorColor: Theme.of(context).secondaryHeaderColor,
                decoration: InputDecoration(
                  hintText: "Description (optional)",
                  hintStyle: TextStyle(
                    color: Theme.of(context).textTheme.titleLarge?.color,
                    fontSize: 18,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (String value) {
                  userDescription = value;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
