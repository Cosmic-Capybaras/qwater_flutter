import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/map_screen.dart';
import '../screens/settings_screen.dart';

class NavigationBarWidget extends StatefulWidget {
  final int initialIndex;

  NavigationBarWidget({this.initialIndex = 0});

  @override
  _NavigationBarWidgetState createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        switch (index) {
          case 0:
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainScreen()));
            break;
          case 1:
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MapScreen()));
            break;
          case 2:
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SettingsScreen()));
            break;
        }
      },
    );
  }
}

