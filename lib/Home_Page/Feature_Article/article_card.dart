import 'package:flutter/material.dart';
import 'articlejp1.dart';
import 'articlejp2.dart';
import 'articlejp3.dart';
import 'articlekfc.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final Widget destinationPage;

  const ArticleCard({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.destinationPage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              imageUrl,
              width: 150, // Adjust the width as per your requirement
              height: 100, // Adjust the height as per your requirement
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 97, 94, 252),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => destinationPage),
                      );
                    },
                    child: const Text('View More'),
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

class ArticleList extends StatelessWidget {
  const ArticleList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const <Widget>[
        ArticleCard(
          title: 'Jatim Park 1',
          imageUrl: 'assets/img/jatim1.jpg',
          destinationPage: ArticleJP1(), // Navigate to ArticleJP1 page
        ),
        ArticleCard(
          title: 'Jatim Park 2',
          imageUrl: 'assets/img/jatim2.jpg',
          destinationPage: ArticleJP2(), // Navigate to ArticleJP2 page
        ),
        ArticleCard(
          title: 'Jatim Park 3',
          imageUrl: 'assets/img/jatim3.jpg',
          destinationPage: ArticleJP3(), // Navigate to ArticleJP3 page
        ),
        ArticleCard(
          title: 'KFC',
          imageUrl: 'assets/img/kfc.jpg',
          destinationPage: ArticleKFC(), // Navigate to ArticleKFC page
        ),
        // Add more ArticleCards as needed
      ],
    );
  }
}
