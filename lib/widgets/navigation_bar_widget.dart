import 'package:flutter/material.dart';
import '../screens/main_screen.dart';
import '../screens/map_screen.dart';
import '../screens/settings_screen.dart';

class NavigationBarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Główny'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Mapa'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ustawienia'),
      ],
      onTap: (index) {
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
