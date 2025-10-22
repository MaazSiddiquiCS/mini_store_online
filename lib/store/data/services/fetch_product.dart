import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mini_online_store/store/data/model/class_product.dart';

Future<List<Product>> fetchProduct() async {
  final response = await http.get(
    Uri.parse('https://fakestoreapi.com/products'),
  );
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = jsonDecode(response.body);
    return jsonData
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  } else {
    throw Exception('failed to load photos');
  }
}
