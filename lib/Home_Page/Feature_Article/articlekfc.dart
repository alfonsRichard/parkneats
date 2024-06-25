import 'package:flutter/material.dart';

class ArticleKFC extends StatelessWidget {
  const ArticleKFC({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
          color: Colors.white,
        ),
        title: const Text('KFC'),
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
                'KFC\nTHE BEST FAST FOOD',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  'assets/img/kfclogo.png',
                  height: 200, // Adjust the height as needed
                  width: 200, // Adjust the width as needed
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'KFC (Kentucky Fried Chicken) is a leading fast-food restaurant known for its crispy and delicious fried chicken. Founded by Colonel Harland Sanders in the 1930s.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'MENU FAVORITES',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              menuCard(
                'Original Recipe Chicken',
                'assets/img/chicken.jpg',
                'Pieces of chicken with KFC\'s signature blend of spices, tender and crispy.',
              ),
              menuCard(
                'Spicy Chicken',
                'assets/img/spicychicken.png',
                'Fried chicken with a spicy flavor that awakens the taste buds.',
              ),
              menuCard(
                'Zinger Burger',
                'assets/img/zingerburger.png',
                'Burger with juicy and crispy chicken fillet.',
              ),
              menuCard(
                'KFC Fries',
                'assets/img/fries.png',
                'Crispy and savory French fries, perfect as a side to chicken meals.',
              ),
              menuCard(
                'KFC Bucket',
                'assets/img/bucket.png',
                'A large bucket of KFC fried chicken to enjoy with family and friends.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuCard(String title, String imageUrl, String description) {
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
