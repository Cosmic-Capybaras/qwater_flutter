import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsHelper {
  static const _selectedLocationKey = 'selected_location_id';

  static Future<int> getSelectedLocationId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_selectedLocationKey) ?? 1;
  }

  static Future<void> setSelectedLocationId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(_selectedLocationKey, id);
  }
}
