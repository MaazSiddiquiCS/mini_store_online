import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

Future <List<int>> loadFavoriteIds() async{
  final prefs= await SharedPreferences.getInstance();
  final stringIds= prefs.getStringList('favorites')??[];
  return stringIds.map(int.parse).toList();
}

Future <void> saveFavoriteIds(List<int> ids) async{
  final prefs= await SharedPreferences.getInstance();
  final stringIds= ids.map((e)=>e.toString()).toList();
  await prefs.setStringList('favorites',stringIds);
}