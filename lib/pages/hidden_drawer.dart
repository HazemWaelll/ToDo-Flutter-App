import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:todolist_app/pages/home_page.dart';
import 'package:todolist_app/pages/settings.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> pages = [];

  final drawerTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.white,
    fontSize: 18,
  );

  @override
  void initState() {
    super.initState();

    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'To Do',
          baseStyle: drawerTextStyle,
          selectedStyle: drawerTextStyle,
          colorLineSelected: Color.fromARGB(255, 171, 143, 250),
        ),
        HomePage(),
      ),

      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: drawerTextStyle,
          selectedStyle: drawerTextStyle,
          colorLineSelected: Color.fromARGB(255, 171, 143, 250),
        ),
        Settings(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.deepPurple,
      screens: pages,
      initPositionSelected: 0,
      slidePercent: 50,
      styleAutoTittleName: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      isTitleCentered: true,
      backgroundColorAppBar: Colors.deepPurple,
      leadingAppBar: Icon(Icons.menu, color: Colors.white),
    );
  }
}
