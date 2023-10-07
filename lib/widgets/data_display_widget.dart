import 'package:flutter/material.dart';

class DataDisplayWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Dane 1: 12345"),
          SizedBox(height: 8.0),
          Text("Dane 2: abcde"),
        ],
      ),
    );
  }
}
