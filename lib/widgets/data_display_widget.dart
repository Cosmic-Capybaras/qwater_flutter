import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DataDisplayWidget extends StatefulWidget {
  @override
  _DataDisplayWidgetState createState() => _DataDisplayWidgetState();
}

class _DataDisplayWidgetState extends State<DataDisplayWidget> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var response = await http.get(Uri.parse('http://188.68.247.32:9000/api/latest-data/10'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(utf8.decode(response.bodyBytes));
      });
    } else {
      print("Failed to load data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: data != null
          ? Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${data!['location_title']}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  Icon(Icons.location_city, color: Colors.blue),
                  SizedBox(width: 8.0),
                  Text("${data!['location_city']}"),
                  Spacer(),
                  Icon(Icons.flag, color: Colors.blue),
                  SizedBox(width: 8.0),
                  Text("${data!['location_country']}"),
                ],
              ),
              SizedBox(height: 8.0),
              Text(
                "${data!['description']}",
                style: TextStyle(fontSize: 16.0, fontStyle: FontStyle.italic),
              ),
              Divider(height: 16.0, color: Colors.blue),
              ...data!['data_values'].map<Widget>((value) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text("${value['data_type_name']}: ", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("${value['value'] ?? value['string_value']}"),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      )
          : Center(child: CircularProgressIndicator()), // Loading indicator
    );
  }
}
