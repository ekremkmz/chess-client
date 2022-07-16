import 'package:shared_preferences/shared_preferences.dart' as sp;

class SharedPreferences {
  late sp.SharedPreferences _prefs;

  Future<SharedPreferences> init() async {
    _prefs = await sp.SharedPreferences.getInstance();
    return this;
  }

  Future<bool> setString(SPStringKey key, String value) async {
    return _prefs.setString(key.name, value);
  }
}

abstract class _SPKey {}

enum SPStringKey implements _SPKey {
  theme,
}
