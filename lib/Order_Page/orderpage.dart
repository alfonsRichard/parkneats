import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:myapp/Home_Page/homepage.dart';
import 'package:myapp/Order_Page/bundlepackage.dart';
import 'package:myapp/Order_Page/signaturebox.dart';
import 'package:myapp/navbar.dart';
import 'package:myapp/Order_Page/everydayvalue.dart';
import 'package:myapp/Order_Page/emptycart.dart';
import 'package:myapp/Order_Page/cartfood.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final int _currentIndex = 2;

  final List<String> imgList = [
    'assets/img/kfc3.jpg',
    'assets/img/kfc.jpg',
    'assets/img/kfc2.jpg',
  ];

  final List<Map<String, String>> bestSellingItems = [
    {
      'title': 'Crispy Chicken Bucket',
      'name': 'Crispy Chicken Bucket',
      'description': 'Crispy Chicken Bucket',
      'imageUrl': 'assets/img/crispychicken.png',
      'price': '30000',
    },
    {
      'title': 'Special Crispy Burger',
      'name': 'Special Crispy Burger',
      'description': 'Special Crispy Burger',
      'imageUrl': 'assets/img/burger.png',
      'price': '30000',
    },
    {
      'title': 'Spicy Chicken Wings',
      'name': 'Spicy Chicken Wings',
      'description': 'Spicy Chicken Wings',
      'imageUrl': 'assets/img/spicywings.png',
      'price': '25000',
    },
    {
      'title': 'Fun Fries',
      'name': 'Fun Fries',
      'description': 'Fun Fries',
      'imageUrl': 'assets/img/kfc5.png',
      'price': '15000',
    },
  ];

  final GetStorage storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
        backgroundColor: Colors.white,
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Order',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Center(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 35),
                    Image.asset(
                      'assets/img/logokfc.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, color: Color.fromARGB(255, 97, 94, 252), size: 35),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartFoodPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 150,
                  autoPlay: true,
                  enlargeCenterPage: true,
                ),
                items: imgList.map((item) => Center(
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000),
                )).toList(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Text(
                    'Menu Category',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCategoryCard('Everyday Value', 'assets/img/everydayvalue.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EverydayValuePage()),
                        );
                      }),
                      _buildCategoryCard('Bundle Package', 'assets/img/bundlepackage.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BundlePackagePage()),
                        );
                      }),
                      _buildCategoryCard('Signature Box', 'assets/img/signaturebox.png', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SignatureBoxPage()),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Best Selling',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildBestSellingList(),
                ]),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex),
    );
  }

  Widget _buildCategoryCard(String title, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: const Color.fromARGB(255, 189, 189, 245),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imageUrl, height: 50, width: 50),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestSellingCard(String title, String imageUrl, String name, String description, int price) {
    return Card(
      color: const Color.fromARGB(255, 189, 189, 245),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    imageUrl,
                    height: 110,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 97, 94, 252),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  _addCardToStorage(name, description, price, imageUrl, 1);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestSellingList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: bestSellingItems.length,
      itemBuilder: (context, index) {
        final item = bestSellingItems[index];
        return _buildBestSellingCard(
          item['title']!,
          item['imageUrl']!,
          item['name']!,
          item['description']!,
          int.parse(item['price']!),
        );
      },
    );
  }

  void _addCardToStorage(String name, String description, int price, String imageUrl, int quantity) {
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
}
