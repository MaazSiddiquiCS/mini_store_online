import 'package:flutter/material.dart';
import 'package:mini_online_store/store/data/model/class_product.dart';
import 'package:mini_online_store/store/data/services/preferences.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteProductId = [];

  List<int> get favoriteProductId => _favoriteProductId;
  bool isFavorite(int productId) => _favoriteProductId.contains(productId);

  Future<void> loadFavorites() async {
    final storedIds = await loadFavoriteIds();
    _favoriteProductId
      ..clear()
      ..addAll(storedIds);
    notifyListeners();
  }

  Future<void> toggleFavorites(Product product) async {
    if(isFavorite(product.id))
    {
      _favoriteProductId.remove(product.id);
    }
    else{
      _favoriteProductId.add(product.id);
    }
    await saveFavoriteIds(_favoriteProductId);
    notifyListeners();
  }
}
