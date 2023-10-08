import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../shared_prefs_helper.dart';
import '../widgets/navigation_bar_widget.dart';
import 'dart:html';
import 'package:google_maps/google_maps.dart' as gmaps;
import 'dart:ui_web' as ui_web;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'main_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<dynamic> locations = [];
  late Future<List<dynamic>> _locationsFuture;

  Future<List<dynamic>> _fetchLocations() async {
    final response =
        await http.get(Uri.parse('http://188.68.247.32:9000/api/locations/'));
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
    var location =
        locations.firstWhere((loc) => loc['id'] == id, orElse: () => null);
    return location?['title'];
  }

  String formatDateTime(String dateTimeStr) {
    var inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss'Z'");
    DateTime dateTime = inputFormat.parse(dateTimeStr);
    var outputFormat = DateFormat.yMMMd().add_jm();
    return outputFormat.format(dateTime);
  }

  Future<void> _showDetails(int id) async {
    final response = await http
        .get(Uri.parse('http://188.68.247.32:9000/api/latest-data/$id'));

    if (response.statusCode == 200) {
      var data = json.decode(utf8.decode(response.bodyBytes));
      var locationTitle = data['location_title'];

      if (mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PointerInterceptor(
              child: AlertDialog(
                titlePadding: EdgeInsets.all(20.0),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                title: Text(
                  locationTitle ?? "Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (data['description'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Description:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (data['description'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text("${data['description']}"),
                        ),
                      if (data['test_date'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Date:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (data['test_date'] != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text("${formatDateTime(data['test_date'])}"),
                        ),
                      Divider(),
                      for (var item in data['data_values'])
                        if (item['data_type_name'] != null &&
                            (item['value'] != null ||
                                item['string_value'] != null))
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${item['data_type_name']}:",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                    "${item['value'] ?? item['string_value']}"),
                              ],
                            ),
                          ),
                      if (data['data_values'].length == 0)
                        Text("No available data"),
                    ],
                  ),
                ),
                actions: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        child: Text(
                          "Set as default",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () async {
                          await SharedPrefsHelper.setSelectedLocationId(id);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(
                              builder: (context) => MainScreen()));
                        },
                      ),
                      TextButton(
                        child: Text("Close"),
                        onPressed: () async {
                          await SharedPrefsHelper.setSelectedLocationId(id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }
    } else {
      // Handle the error accordingly
      print('Failed to load data for location $id');
    }
  }

  Widget getMap() {
    String htmlId = DateTime.now().millisecondsSinceEpoch.toString();

    ui_web.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      final myLatlng = gmaps.LatLng(52, 19.5);

      final mapOptions = gmaps.MapOptions()
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

      final map = gmaps.GMap(elem, mapOptions);
      for (var location in locations) {
        final latLng =
            gmaps.LatLng(location['latitude'], location['longitude']);
        final marker = gmaps.Marker(gmaps.MarkerOptions()
          ..position = latLng
          ..map = map
          ..title = location['title']);

        marker.onClick.listen((_) {
          _showDetails(location['id']);
        });
      }

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
