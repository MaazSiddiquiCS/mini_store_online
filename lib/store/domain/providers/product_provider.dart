import 'package:flutter/material.dart';
import 'package:mini_online_store/store/data/model/class_product.dart';
import 'package:mini_online_store/store/data/services/fetch_product.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _selectedCategory = 'ALL';
  String get selectedCategory => _selectedCategory;

  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts.isEmpty && _searchQuery.isEmpty && _selectedCategory == 'ALL'
      ? _products
      : _filteredProducts;

  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await fetchProduct();
      _filteredProducts = List.from(_products);
    } catch (e) {
      _errorMessage = 'Error loading products';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchByName(String query) {
    _searchQuery = query.toLowerCase();
    _applyFilters();
  }

  void searchByCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesName = product.title.toLowerCase().contains(_searchQuery);
      final matchesCategory =
          _selectedCategory == 'ALL' ? true : product.category == _selectedCategory;
      return matchesName && matchesCategory;
    }).toList();

    notifyListeners();
  }
String _selectedSort = "None";
String get selectedSort => _selectedSort;

void sortByPrice(String sortOption) {
  _selectedSort = sortOption;

  if (_filteredProducts.isNotEmpty) {
    if (sortOption == "Price: Low to High") {
      _filteredProducts.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == "Price: High to Low") {
      _filteredProducts.sort((a, b) => b.price.compareTo(a.price));
    }
  } else {
    if (sortOption == "Price: Low to High") {
      _products.sort((a, b) => a.price.compareTo(b.price));
    } else if (sortOption == "Price: High to Low") {
      _products.sort((a, b) => b.price.compareTo(a.price));
    }
  }

  notifyListeners();
}


}