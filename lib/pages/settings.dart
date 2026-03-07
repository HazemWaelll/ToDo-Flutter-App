import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late var BottomSheetTextStyle;
  @override
  Widget build(BuildContext context) {
    BottomSheetTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).hintColor,
    );
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: Padding(
        padding: EdgeInsets.only(top: 26, bottom: 16, left: 16, right: 16),
        child: GestureDetector(
          onTap: () => changeTheme(),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 70,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      "Change Theme",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).canvasColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: Offset(-8, 0),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Theme.of(context).canvasColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future changeTheme() {
    return showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              title: Text('Light Theme', style: BottomSheetTextStyle),
              onTap: () {
                thememode.value = 'light';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Dark Theme', style: BottomSheetTextStyle),
              onTap: () {
                thememode.value = 'dark';
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Purple Theme', style: BottomSheetTextStyle),
              onTap: () {
                thememode.value = 'purple';
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
