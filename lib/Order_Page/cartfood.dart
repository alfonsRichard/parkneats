import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'checkoutfood.dart';

class CartFoodPage extends StatefulWidget {
  const CartFoodPage({super.key});

  @override
  _CartFoodPageState createState() => _CartFoodPageState();
}

class _CartFoodPageState extends State<CartFoodPage> {
  final GetStorage storage = GetStorage();
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() {
    List<dynamic> storedItems = storage.read<List<dynamic>>('cart_items') ?? [];
    setState(() {
      cartItems = storedItems.cast<Map<String, dynamic>>();
    });
  }

  void incrementQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] += 1;
      storage.write('cart_items', cartItems);
    });
  }

  void decrementQuantity(int index) {
    setState(() {
      if (cartItems[index]['quantity'] > 1) {
        cartItems[index]['quantity'] -= 1;
      } else {
        cartItems.removeAt(index);
      }
      storage.write('cart_items', cartItems);
    });
  }

  int calculateTotal() {
    int total = 0;
    for (var item in cartItems) {
      total += (item['price'] as int) * (item['quantity'] as int);
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    String formatRupiah(int amount) {
      String amountStr = amount.toString();
      String result = '';
      int count = 0;
      for (int i = amountStr.length - 1; i >= 0; i--) {
        result = amountStr[i] + result;
        count++;

        if (count == 3 && i != 0) {
          result = '.' + result;
          count = 0;
        }
      }

      result = 'Rp' + result;
      return result;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Cart"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          return FoodItemCard(
            name: item['name'],
            description: item['description'],
            price: item['price'],
            imageUrl: item['imageUrl'],
            quantity: item['quantity'],
            onIncrement: () => incrementQuantity(index),
            onDecrement: () => decrementQuantity(index),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:  ${formatRupiah(calculateTotal())}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CheckoutFoodPage()),
                  );
                },
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 97, 94, 252),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodItemCard extends StatelessWidget {
  final String name;
  final String description;
  final int price;
  final String imageUrl;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const FoodItemCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    String formatRupiah(int amount) {
      String amountStr = amount.toString();
      String result = '';
      int count = 0;
      for (int i = amountStr.length - 1; i >= 0; i--) {
        result = amountStr[i] + result;
        count++;

        if (count == 3 && i != 0) {
          result = '.' + result;
          count = 0;
        }
      }

      result = 'Rp' + result;
      return result;
    }

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
                  Row(
                    children: [
                      Text(
                        "${formatRupiah(price)}",
                        style: const TextStyle(fontSize: 18, color: Colors.black54, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: onDecrement,
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: onIncrement,
                      ),
                    ],
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
