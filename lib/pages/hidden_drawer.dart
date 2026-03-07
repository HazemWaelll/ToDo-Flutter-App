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
  late TextStyle drawerTextStyle;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    drawerTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).canvasColor,
      fontSize: 18,
    );

    pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'To Do',
          baseStyle: drawerTextStyle,
          selectedStyle: drawerTextStyle,
          colorLineSelected: Theme.of(context).scaffoldBackgroundColor,
        ),
        HomePage(),
      ),

      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: drawerTextStyle,
          selectedStyle: drawerTextStyle,
          colorLineSelected: Theme.of(context).scaffoldBackgroundColor,
        ),
        Settings(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Theme.of(context).primaryColor,
      screens: pages,
      initPositionSelected: 0,
      slidePercent: 50,
      styleAutoTittleName: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).canvasColor,
      ),
      isTitleCentered: true,
      backgroundColorAppBar: Theme.of(context).primaryColor,
      leadingAppBar: Icon(Icons.menu, color: Theme.of(context).canvasColor),
    );
  }
}
