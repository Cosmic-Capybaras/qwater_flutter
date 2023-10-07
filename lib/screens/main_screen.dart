import 'dart:math';

import 'package:flutter/material.dart';
import '../widgets/logo_widget.dart';
import '../widgets/data_display_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/navigation_bar_widget.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: 500.0,
              maxWidth: max(500.0, MediaQuery.of(context).size.width * 0.5),
            ),
            child: Column(
              children: [
                LogoWidget(),
                DataDisplayWidget(),
                ChartWidget(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWidget(initialIndex: 0),
    );
  }
}
