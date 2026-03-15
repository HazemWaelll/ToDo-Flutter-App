import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todolist_app/pages/hidden_drawer.dart';
import 'package:provider/provider.dart';

final thememode = ValueNotifier<String>('light');
late Box<dynamic> _themeBox;

final Map<String, ThemeData> themesList = {
  'light': ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 217, 217, 217),
    primaryColor: Colors.white,
    secondaryHeaderColor: Colors.black,
    shadowColor: Colors.black26,
    canvasColor: Colors.black,
    hintColor: Colors.black,
    appBarTheme: AppBarTheme(toolbarHeight: 70),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.grey[700]),
    ),
    splashColor: Colors.white,
    focusColor: const Color.fromARGB(255, 217, 217, 217),
  ),
  'dark': ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 36, 36, 36),
    primaryColor: Colors.black,
    secondaryHeaderColor: Colors.white,
    shadowColor: Colors.black26,
    canvasColor: Colors.white,
    hintColor: Colors.white,
    appBarTheme: AppBarTheme(toolbarHeight: 70),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.grey[400]),
    ),
    splashColor: const Color.fromARGB(255, 36, 36, 36),
    focusColor: Colors.white,
  ),
  'purple': ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 171, 143, 250),
    primaryColor: Colors.deepPurple,
    secondaryHeaderColor: Colors.deepPurple[600],
    shadowColor: Colors.black26,
    canvasColor: Colors.white,
    hintColor: Colors.white,
    appBarTheme: AppBarTheme(toolbarHeight: 70),
    textTheme: TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      titleMedium: TextStyle(color: Colors.grey[850]),
    ),
    splashColor: Colors.deepPurple,
    focusColor: const Color.fromARGB(255, 171, 143, 250),
  ),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
  _themeBox = await Hive.openBox('themeBox');

  // load saved theme
  final savedTheme = _themeBox.get('themeMode', defaultValue: 'light');
  thememode.value = themesList.containsKey(savedTheme) ? savedTheme : 'light';

  // notifyListeners and save it
  thememode.addListener(() {
    _themeBox.put('themeMode', thememode.value);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) {},
      child: ValueListenableBuilder<String>(
        valueListenable: thememode,
        builder: (context, themevalue, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: HiddenDrawer(),
            theme: themesList[themevalue],
          );
        },
      ),
    );
  }
}
