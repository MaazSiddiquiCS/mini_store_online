import 'package:flutter/material.dart';
import 'package:mini_online_store/store/data/model/class_product.dart';
import 'package:mini_online_store/store/domain/providers/favorite_provider.dart';
import 'package:mini_online_store/store/presentation/screens/detail_screen.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product productCard;
  const ProductCard({super.key, required this.productCard});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(productDetail: productCard),
        ),
      ),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    productCard.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                productCard.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\$${productCard.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w600),
                  ),
                  Selector<FavoriteProvider, bool>(
                    selector: (_, favProvider) =>
                        favProvider.isFavorite(productCard.id),
                    builder: (context, isFav, _) {
                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                        ),
                        onPressed: () {
                          context
                              .read<FavoriteProvider>()
                              .toggleFavorites(productCard);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
