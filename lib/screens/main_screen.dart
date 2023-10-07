import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/location_name_widget.dart';
import '../widgets/data_display_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/navigation_bar_widget.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            LogoWidget(),
            LocationNameWidget(),
            DataDisplayWidget(),
            ChartWidget(),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(),
    );
  }
}
