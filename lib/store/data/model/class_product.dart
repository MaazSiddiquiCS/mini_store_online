class Product {
  final int id;
  final String title;
  final String category;
  final num price;
  final String image;

  const Product({
    required this.id,
    required this.category,
    required this.image,
    required this.price,
    required this.title,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': int id,
        'title': String title,
        'category': String category,
        'price': num price,
        'image': String image,
      } =>
        Product(
          id: id,
          category: category,
          image: image,
          price: price.toDouble(),
          title: title,
        ),
        _=> throw Exception('Failed to Load Products')
    };
  }
}
