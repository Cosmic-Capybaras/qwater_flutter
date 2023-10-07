// map_screen.dart
import 'package:flutter/material.dart';
import '../widgets/navigation_bar_widget.dart';

class MapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Mapa Google tutaj")),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}