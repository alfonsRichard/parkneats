import 'package:flutter/material.dart';
import 'package:myapp/Order_Page/paymentsuccess.dart'; // Import PaymentSuccessPage
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckoutFoodPage extends StatelessWidget {
  const CheckoutFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    List<dynamic> cartItems = box.read<List<dynamic>>('cart_items') ?? [];

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

    int calculateTotal() {
      int total = 0;
      for (var item in cartItems) {
        total += (item['price'] as int) * (item['quantity'] as int);
      }
      return total;
    }

    int calculateTax(int total) {
      return (total * 0.10).round();
    }

    int tax = calculateTax(calculateTotal());
    int totalAmount = calculateTotal() + tax;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            "Order List:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (var item in cartItems)
            FoodItemCard(
              name: item['name'],
              price: item['price'],
              imageUrl: item['imageUrl'],
              quantity: item['quantity'],
            ),
          const SizedBox(height: 16),
          const Text(
            "Payment Method:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 240, 240, 240),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "My Balance",
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.black54,
                        ),
                        SizedBox(width: 8),
                        Text(
                          '${formatRupiah(box.read('saldo') ?? 0)}',
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                    color: const Color.fromARGB(255, 240, 240, 240),
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Order Summary:",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Items:     ${formatRupiah(calculateTotal())}",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            "Tax:         ${formatRupiah(tax)}",
            style: TextStyle(fontSize: 16),
          ),
          Text(
            "Total:      ${formatRupiah(totalAmount)}",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:   ${formatRupiah(totalAmount)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  int total = calculateTotal();
                  int tax = calculateTax(total);
                  int totalAmount = total + tax;
                  int saldo = box.read('saldo');

                  if (saldo < totalAmount) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Insufficient balance!'),
                      ),
                    );
                    return;
                  }

                  final email = box.read('email') ?? 'test@gmail.com';
                  final tanggal = DateTime.now()
                      .toString()
                      .substring(0, 10); // Current date in YYYY-MM-DD format
                  final judul = cartItems
                      .map((item) => item['name'])
                      .join(", "); // All items in cart
                  final url =
                      'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/history.json';

                  final response = await http.post(
                    Uri.parse(url),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode(<String, dynamic>{
                      'email': email,
                      'judul': judul,
                      'tanggal': tanggal,
                      'total_harga': totalAmount,
                      'subtotal': total,
                      'tax': tax,
                    }),
                  );

                  if (response.statusCode == 200) {
                    // Successfully posted data
                    print('Payment success data posted');

                    final String firebaseUrl =
                        'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/users.json';

                    // Fetch user balance from Firebase
                    final responseUser = await http.get(Uri.parse(firebaseUrl));
                    if (responseUser.statusCode == 200) {
                      final Map<String, dynamic> usersData =
                          jsonDecode(responseUser.body);
                      int currentBalance = 0;
                      String userId = '';

                      usersData.forEach((key, value) {
                        if (value['email'] == email) {
                          currentBalance = value['saldo'];
                          userId = key;
                        }
                      });

                      if (currentBalance >= totalAmount) {
                        final newBalance = currentBalance - totalAmount;
                        final updateResponse = await http.patch(
                          Uri.parse(
                              'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json'),
                          body: jsonEncode({'saldo': newBalance}),
                        );

                        if (updateResponse.statusCode == 200) {
                          // Save new balance to GetStorage
                          await box.write('saldo', newBalance);
                          await box.remove('cart_items');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PaymentSuccessPage()),
                          );
                        } else {
                          print('Failed to update saldo');
                        }
                      }
                    } else {
                      print('Failed to get user data');
                    }
                  } else {
                    print('Failed to post payment success data');
                  }
                },
                child: const Text(
                  "Pay",
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
  final int price;
  final String imageUrl;
  final int quantity;

  const FoodItemCard({
    super.key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.quantity,
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
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "${formatRupiah(price)}",
                    style: const TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text("x$quantity"),
          ],
        ),
      ),
    );
  }
}
