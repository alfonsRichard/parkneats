import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myapp/Home_Page/homepage.dart';
import 'package:myapp/Ticket_Page/ticket1page.dart';
import 'package:myapp/Ticket_Page/ticket2page.dart';
import 'package:myapp/Ticket_Page/ticket3page.dart';
import 'package:myapp/navbar.dart';

class TicketPage extends StatefulWidget {
  const TicketPage({super.key});

  @override
  _TicketPageState createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  final List<Map<String, String>> parkLocations = [
    {
      'name': 'Jatim Park 1',
      'address': 'Jl. Kartika No. 2, Kota Wisata Batu, Jawa Timur',
      'image': 'assets/img/jatim1.jpg',
    },
    {
      'name': 'Jatim Park 2',
      'address': 'Jl. Oro-oro Ombo No. 9, Kecamatan Batu, Malang, Jawa Timur',
      'image': 'assets/img/jatim2.jpg',
    },
    {
      'name': 'Jatim Park 3',
      'address': 'Jalan Raya Ir. Soekarno No.144, Beji, Kota Batu, Jawa Timur',
      'image': 'assets/img/jatim3.jpg',
    },
  ];

  final int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: const Text('Ticket'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ImageSlider(),
            const SizedBox(
              height: 10,
            ), // Jarak antara ImageSlider dan teks "Jatim Park Location"
            const Text(
              'Jatim Park Location',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: parkLocations.map((park) {
                  return InkWell(
                    onTap: () {
                      if (park['name'] == 'Jatim Park 1') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketOnlyPage(),
                          ),
                        );
                      } else if (park['name'] == 'Jatim Park 2') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketOnly2Page(),
                          ),
                        );
                      } else if (park['name'] == 'Jatim Park 3') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TicketOnly3Page(),
                          ),
                        );
                      }
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: ListTile(
                        leading: Image.asset(park['image']!),
                        title: Text(park['name']!),
                        subtitle: Text(park['address']!),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex),
    );
  }
}

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _currentIndex = 0;
  final List<String> images = [
    'assets/img/jatim1.jpg',
    'assets/img/jatim2.jpg',
    'assets/img/jatim3.jpg',
  ];
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.8, // Menampilkan sedikit lebih banyak dari satu gambar sekaligus
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < images.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img/logojtp.png', height: 40), // Adjust the height to make it smaller
            const SizedBox(width: 10), // Adjust the space between images and the "X"
            const Text(
              'X',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 10), // Adjust the space between images and the "X"
            Image.asset('assets/img/logoapp2.png', height: 40), // Adjust the height to make it smaller
          ],
        ),
        const SizedBox(height: 20), // Jarak antara logo dan carousel slider
        SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0), // Menambahkan jarak horizontal di sekitar PageView
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30.0), // Membuat ujung gambar melengkung
                      child: Transform.scale(
                        scale: 0.9,
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                Positioned.fill(
                  top: 10,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 40,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: images.map((url) {
            int index = images.indexOf(url);
            return Container(
              width: 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? const Color.fromRGBO(0, 0, 0, 0.9)
                    : const Color.fromRGBO(0, 0, 0, 0.4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
