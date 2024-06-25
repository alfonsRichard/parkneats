import 'package:flutter/material.dart';

class ArticleJP1 extends StatelessWidget {
  const ArticleJP1({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const Text('Jawa Timur Park 1'),
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
                'JAWA TIMUR PARK 1\nPLAY AND LEARN SCIENCE',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jawa Timur Park 1 is a recreational place with a concept of amusement park combined with educational park.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'POPULAR RIDES',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              rideCard(
                'Himalaya Coaster',
                'assets/img/himalayacoaster.jpeg',
                'A roller coaster ride that will take you across mountains to the peak, then spiral down at high speed through rocky terrains.',
              ),
              rideCard(
                'Sky Swinger',
                'assets/img/skyswinger.jpg',
                'Enjoy the view of Batu City from high above while swinging with someone special.',
              ),
              rideCard(
                'Funtastic Swimming Pool',
                'assets/img/funtasticswimmingpool.jpg',
                'The largest water attraction owned by Jawa Timur Park Group. Make your holiday extraordinary with this cheerful swimming pool.',
              ),
              rideCard(
                'Dragon Coaster',
                'assets/img/dragoncoaster.jpg',
                'Who says dragons are extinct? At Science & Coaster Park, you can ride high-speed dragons alone or with your friends.',
              ),
              rideCard(
                'Flying Tornado',
                'assets/img/flyingtornado.jpeg',
                'Spin like a tornado with an exhilarating duration. Flying Tornado is a challenging ride that you must try.',
              ),
              rideCard(
                'Superman Coaster',
                'assets/img/supermancoaster.jpg',
                'Superman Coaster offers a fast-moving roller coaster experience with sharp turns and gravitational twists.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rideCard(String title, String imageUrl, String description) {
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
