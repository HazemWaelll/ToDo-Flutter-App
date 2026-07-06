import 'package:flutter/material.dart';
import 'package:todolist_app/main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late var BottomSheetTextStyle;
  @override
  Widget build(BuildContext context) {
    BottomSheetTextStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).hintColor,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Settings",
          style: TextStyle(
            color: Theme.of(context).canvasColor,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),

        leading: BackButton(color: Theme.of(context).canvasColor),
      ),

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
              title: Text('Purple Theme', style: BottomSheetTextStyle),
              onTap: () {
                thememode.value = 'purple';
                Navigator.pop(context);
              },
            ),

            ListTile(
              title: Text('peach pink Theme', style: BottomSheetTextStyle),
              onTap: () {
                thememode.value = 'peach pink';
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
