import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'cartfood.dart';

class BundlePackagePage extends StatelessWidget {
  const BundlePackagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Bundle Package",
              style: TextStyle(
                fontSize: 18, // smaller font size
                fontWeight: FontWeight.bold, // bold text
              ),
            ),
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 97, 94, 252)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartFoodPage()),
                );
              },
            ),
          ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          FoodItemCard(
            name: "Krunch Chicken Combo + 1 Ticket Jatim Park Fast Track",
            description: "Krunch Chicken Combo with Ticket Fast Track to Jatim Park 1 2 3",
            price: 150000,
            imageUrl: 'assets/img/bundlepackage.png',
          ),
          FoodItemCard(
            name: "2 Meal Deal Box + 2 Ticket Jatim Park Fast Track",
            description: "2 Meal Deal Box with 2 Ticket Fast Track to Jatim Park 1 2 3",
            price: 300000,
            imageUrl: 'assets/img/mealdeal1.jpeg',
          ),
          FoodItemCard(
            name: "2 Super Bundle + 4 Ticket Jatim Park Fast Track",
            description: "2 Super Bundle with 4 Ticket Fast Track to Jatim Park 1 2 3",
            price: 550000,
            imageUrl: 'assets/img/superbundle.jpg',
          ),
        ],
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imageUrl;

  const FoodItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  void _addCardToStorage(String name, String description, int price, String imageUrl, int quantity) {
    final storage = GetStorage();
    List<dynamic> savedItems = storage.read<List<dynamic>>('cart_items') ?? [];
    bool itemExists = false;

    for (var item in savedItems) {
      if (item['name'] == name) {
        item['quantity'] += quantity;
        itemExists = true;
        break;
      }
    }

    if (!itemExists) {
      Map<String, dynamic> newItem = {
        'name': name,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
        'quantity': quantity,
      };
      savedItems.add(newItem);
    }

    storage.write('cart_items', savedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Image.asset(
              imageUrl,
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Rp. ${price.toString()}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _addCardToStorage(name, description, price, imageUrl, 1);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$name added to cart'))
                      );
                    },
                    child: const Text(
                      "Add to Cart",
                      style: TextStyle(color: Colors.white), // Set text color to white
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 97, 94, 252),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
