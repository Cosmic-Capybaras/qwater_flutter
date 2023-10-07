// settings_screen.dart
import 'package:flutter/material.dart';
import '../widgets/navigation_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Ustawienia")),
      bottomNavigationBar: NavigationBarWidget(initialIndex: 2),
    );
  }
}