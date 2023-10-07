import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/navigation_bar_widget.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart';
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<dynamic> locations = [];
  late Future<List<dynamic>> _locationsFuture;

  Future<List<dynamic>> _fetchLocations() async {
    final response = await http.get(Uri.parse('http://188.68.247.32:9000/api/locations/'));
    if (response.statusCode == 200) {
      locations = json.decode(utf8.decode(response.bodyBytes));
      return locations;
    } else {
      throw Exception('Failed to load locations from API');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _locationsFuture = _fetchLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _locationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return getMap();
          }
        },
      ),
      bottomNavigationBar: NavigationBarWidget(initialIndex: 1),
    );
  }

  String? getLocationTitleById(int id) {
    var location = locations.firstWhere((loc) => loc['id'] == id, orElse: () => null);
    return location?['title'];
  }

  String formatDateTime(String dateTimeStr) {
    var inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
    DateTime dateTime = inputFormat.parse(dateTimeStr);
    var outputFormat = DateFormat.yMMMd().add_jm(); // For example: Oct 7, 2023 5:00 PM
    return outputFormat.format(dateTime);
  }

  Future<void> _showDetails(int id) async {
    final response = await http.get(Uri.parse('http://188.68.247.32:9000/api/latest-data/$id'));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      var locationTitle = data['location_title'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(locationTitle ?? "Details"),  // Display the location title here
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text("Description: ${data['description']}"),
                  // Text("Created at: ${data['created_at']}"),
                  // Text("Date: ${data['test_date']}"),
                  Text("Date: ${formatDateTime(data['test_date'])}"),
                  for (var item in data['data_values'])
                    Text("${item['data_type_name']}: ${item['value'] ?? item['string_value']}"),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // Handle the error accordingly
      print('Failed to load data for location $id');
    }
  }


  Widget getMap() {
    String htmlId = "7";

    ui_web.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = LatLng(52, 19.5);

      final mapOptions = MapOptions()
        ..zoom = 6
        ..center = myLatlng
        ..streetViewControl = false
        ..fullscreenControl = false
        ..zoomControl = false
        ..mapTypeControl = false
        ..gestureHandling = 'greedy';

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);
      for (var location in locations) {
        final latLng = LatLng(location['latitude'], location['longitude']);
        final marker = Marker(MarkerOptions()
          ..position = latLng
          ..map = map
          ..title = location['title']
        );

        marker.onClick.listen((_) {
          _showDetails(location['id']);
        });
      }

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }
}
