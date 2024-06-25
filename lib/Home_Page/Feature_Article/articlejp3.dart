import 'package:flutter/material.dart';

class ArticleJP3 extends StatelessWidget {
  const ArticleJP3({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const Text('Jawa Timur Park 3'),
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
                'JAWA TIMUR PARK 3\nMAKES YOUR IMAGINATION COME TRUE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jatim Park 3 is a popular amusement park with dinosaur attractions, wax museum, and technology exhibitions.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'DISCOVER THE FASCINATING EXPLORATIONS',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              attractionCard(
                'Dino Park',
                'assets/img/dinopark.jpg',
                'The first and largest dinosaur-themed amusement park in Indonesia, equipped with a museum that educates about dinosaurs.',
              ),
              attractionCard(
                'The Legend Star',
                'assets/img/thelegendstar.jpg',
                'The Legend Star is the first in Indonesia to present hundreds of wax statues of world figures and artists, guaranteed to indulge your holiday experience.',
              ),
              attractionCard(
                'Milenial Glow Garden',
                'assets/img/milenialglowgarden.jpg',
                'Milenial Glow Garden is the newest attraction from JTP Group, located within the same area as Jawa Timur Park 3, a garden of a million lights that will delight tourists with beautiful lighting on every side.',
              ),
              attractionCard(
                'Fun Tech Plaza',
                'assets/img/funtechplaza.jpg',
                'Fun Tech Plaza offers a variety of interactive and educational technology exhibitions.',
              ),
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
}
