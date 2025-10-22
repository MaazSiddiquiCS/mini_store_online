import 'package:flutter/material.dart';
import 'package:mini_online_store/store/domain/providers/product_provider.dart';
import 'package:mini_online_store/store/presentation/widgets/product_card.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePage();
}

class _MyHomePage extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "Search by name...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) =>
                  context.read<ProductProvider>().searchByName(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      List<String> categories = provider.products
                          .map((p) => p.category)
                          .toSet()
                          .toList();
                      categories.insert(0, "ALL");

                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: categories.contains(provider.selectedCategory)
                            ? provider.selectedCategory
                            : "ALL",
                        items: categories
                            .map((category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(category),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) provider.searchByCategory(value);
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category_outlined),
                          hintText: "Select category",
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Consumer<ProductProvider>(
                    builder: (context, provider, _) {
                      const sortOptions = [
                        "None",
                        "Price: Low to High",
                        "Price: High to Low"
                      ];
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: sortOptions.contains(provider.selectedSort)
                            ? provider.selectedSort
                            : "None",
                        items: sortOptions
                            .map((sort) => DropdownMenuItem(
                                  value: sort,
                                  child: Text(sort),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) provider.sortByPrice(value);
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.sort),
                          hintText: "Sort by price",
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (provider.errorMessage != null) {
                  return Center(child: Text(provider.errorMessage!));
                } else {
                  final products = provider.filteredProducts.isNotEmpty
                      ? provider.filteredProducts
                      : provider.products;

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(productCard: products[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
