import 'package:flutter/material.dart';
import 'rewardcard.dart'; // Import the RewardCard

class RewardsPage extends StatelessWidget {
  const RewardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 97, 94, 252),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Points',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.white, size: 30),
                      SizedBox(width: 5),
                      Text(
                        '100 Points',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Your Rewards',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const <Widget>[
                  RewardCard(
                    title: 'Paket 1',
                    description: '50 Points\nJatim Park 1 + Snack',
                  ),
                  RewardCard(
                    title: 'Paket 2',
                    description: '75 Points\nJatim Park 2 + Panas 1',
                  ),
                  RewardCard(
                    title: 'Paket 3',
                    description: '100 Points\nJatim Park 3 + Makan Siang',
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
