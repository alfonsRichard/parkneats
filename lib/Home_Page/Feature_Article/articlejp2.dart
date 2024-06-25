import 'package:flutter/material.dart';

class ArticleJP2 extends StatelessWidget {
  const ArticleJP2({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const Text('Jawa Timur Park 2'),
        backgroundColor: const Color.fromARGB(255, 97, 94, 252),
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'JAWA TIMUR PARK 2\nLET\'S EXPLORE THE WILD',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jawa Timur Park 2 is a theme park with educational activities focusing on natural history and biology, including a zoo.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'FEATURED ATTRACTIONS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              attractionCard(
                'Batu Secret Zoo',
                'assets/img/batusecretzoo.jpg',
                'Batu Secret Zoo is a modern wildlife conservation and tourist attraction located in Batu, East Java.',
              ),
              attractionCard(
                'Museum Satwa',
                'assets/img/museumsatwa.jpg',
                'Museum Satwa presents preserved animals in their natural habitats, allowing visitors to observe them up close.',
              ),
              attractionCard(
                'Eco Green Park',
                'assets/img/ecogreenpark.jpg',
                'Adjacent to various birds, experiencing scorpions in your hand, and passing through giant spiders in the artificial forest.',
              ),
              const SizedBox(height: 20),
              const Text(
                'OUR SHOW',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              showImages(),
            ],
          ),
        ),
      ),
    );
  }

  Widget attractionCard(String title, String imageUrl, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Image.asset(imageUrl),
        const SizedBox(height: 5),
        Text(description, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget showImages() {
    final List<String> showList = [
      'assets/img/show1.jpg',
      'assets/img/show2.jpg',
      'assets/img/show3.jpg'
    ];

    return Column(
      children: showList
          .map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Image.asset(item),
              ))
          .toList(),
    );
  }
}
