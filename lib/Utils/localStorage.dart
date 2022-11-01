import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

Future<bool> storeString(String stringTitle, String stringValue) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(stringTitle, stringValue);
  return prefs.commit();
}

Future<bool> storeStringList(
    String stringTitle, List<String> stringValue) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setStringList(stringTitle, stringValue);
  return prefs.commit();
}

Future<String?> getString(String getStringTitle) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String? getValue = prefs.getString(getStringTitle);

  if (getValue == null) {
    return null;
  }
  return getValue;
}

Future<List<String>?> getStringList(String getStringTitle) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? getValue = prefs.getStringList(getStringTitle);

  if (getValue == null) {
    return null;
  }
  return getValue;
}

removeString(String removeStringTitle) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.remove(removeStringTitle);
}

clearStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}
