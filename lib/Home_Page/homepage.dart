import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'Feature_Notes/notes.dart';
import 'Feature_TopUp/topuppage.dart';
import 'Feature_Article/article_card.dart';
import 'Feature_History/historypage.dart';
import 'package:myapp/navbar.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final int _currentIndex = 0;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  bool _isBalanceVisible = true;

  final List<String> imgList = [
    'assets/img/promo1.png',
    'assets/img/promo2.png',
    'assets/img/promo3.png',
    'assets/img/promo10.png',
    'assets/img/promo11.png',
    'assets/img/promo12.png'
  ];
  final box = GetStorage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Home'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CarouselSlider(
                items: imgList.map((item) => Image.asset(item, fit: BoxFit.contain, width: 1000)).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  height: 250, // Adjust the height to accommodate the images
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == entry.key
                            ? const Color.fromARGB(255, 97, 94, 252)
                            : const Color.fromRGBO(0, 0, 0, 0.3),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hi, ${box.read('fullName') ?? "Richard"}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.waving_hand, color: Colors.orange, size: 24),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.shopping_cart,
                        color: Color.fromARGB(255, 97, 94, 252), size: 35),
                    onPressed: () {
                      // Add your onPressed code here!
                    },
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), // Ubah padding horizontal untuk mengurangi lebar kontainer
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 97, 94, 252),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.account_balance_wallet,
                            color: Colors.white, size: 24), // Adjusted icon size
                        SizedBox(width: 5),
                        Text(
                          'Balance',
                          style: TextStyle(
                            fontSize: 25, // Adjusted text size
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _isBalanceVisible ? '${formatRupiah(box.read('saldo') ?? 0)}' : '******',
                          style: const TextStyle(
                            fontSize: 25, // Adjusted text size
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            _isBalanceVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                            size: 27, // Adjusted icon size
                          ),
                          onPressed: () {
                            setState(() {
                              _isBalanceVisible = !_isBalanceVisible;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.blue,
                        child: IconButton(
                          icon: const Icon(Icons.add_circle_outline,
                              color: Colors.white, size: 35),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TopUpPage()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Top Up',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.red,
                        child: IconButton(
                          icon: const Icon(Icons.note_alt_rounded,
                              color: Colors.white, size: 30),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const NotesPage()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('Notes',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.purple,
                        child: IconButton(
                          icon: const Icon(Icons.history_rounded,
                              color: Colors.white, size: 35),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const HistoryPage()),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text('History',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 50),
              const Text(
                'Article For You',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              const ArticleList(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex), // Use the custom navbar
    );
  }
}
