import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'cartfood.dart';

void main() {
  runApp(const MaterialApp(
    home: SignatureBoxPage(),
  ));
}

class SignatureBoxPage extends StatelessWidget {
  const SignatureBoxPage({super.key});

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
              "Signature Box",
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
            name: "Signature Box 1",
            description: "1 Crunch Burger + 1 Hot or Crispy Fried Chicken + 1 Cola",
            price: 65000,
            imageUrl: 'assets/img/signaturebox.png',
          ),
          FoodItemCard(
            name: "Signature Box 2",
            description: "1 Crunch Burger + 3 Hot or Crispy Fried Chicken + 1 Fries + 1 Giant Cola",
            price: 75000,
            imageUrl: 'assets/img/signaturebox2.jpeg',
          ),
          FoodItemCard(
            name: "Signature Box 3",
            description: "1 Giant Taco + 1 Hot or Crispy Fried Chicken + 1 Cola",
            price: 50000,
            imageUrl: 'assets/img/signaturebox3.jpg',
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

  const FoodItemCard({super.key, 
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
