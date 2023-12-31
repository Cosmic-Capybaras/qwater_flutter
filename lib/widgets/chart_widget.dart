import 'package:flutter/material.dart';

class ChartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Charts",
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/temperature_plot_30_days.png', fit: BoxFit.cover),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/oxygen_plot_30_days.png', fit: BoxFit.cover),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/nitrogen_plot_30_days.png', fit: BoxFit.cover),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/transparency_plot_30_days.png', fit: BoxFit.cover),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/max_depth_plot_30_days.png', fit: BoxFit.cover),
          SizedBox(height: 16.0),
          Image.asset('assets/plots/nickel_plot_30_days.png', fit: BoxFit.cover),
        ],
      ),
    );
  }
}
