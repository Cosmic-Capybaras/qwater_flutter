// settings_screen.dart
import 'package:flutter/material.dart';
import '../widgets/navigation_bar_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text("Nothing to change right now")),
      bottomNavigationBar: NavigationBarWidget(initialIndex: 2),
    );
  }
}