import 'package:flutter/material.dart';
import 'package:myapp/Home_Page/homepage.dart';
import 'package:myapp/navbar.dart';
import 'package:myapp/Account_Page/ProfileUserPage.dart';
import 'package:myapp/Home_Page/Feature_TopUp/topuppage.dart';
import 'package:myapp/onboarding.dart';
import 'aboutpage.dart';
import 'helppage.dart'; // Import the onboarding page
import 'package:get_storage/get_storage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final int _currentIndex = 3;
  final box = GetStorage();

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
        title: const Text('Account'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back button
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50),
                  ),
                  SizedBox(width: 10), // Add space between the avatar and text
                  Text(
                    '${box.read('fullName') ?? "Richard"}',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.person_outline), // Add icon
                title: const Text('Profile User'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfileUserPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.shopping_cart_outlined), // Add icon
                title: const Text('My Cart'),
                onTap: () {
                  // Navigator.push(
                  // context,
                  // MaterialPageRoute(builder: (context) => const MyCartPage()),
                  // );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined), // Add icon
                title: const Text('My Balance'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TopUpPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline), // Add icon
                title: const Text('About'),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.help_outline), // Add icon
                title: const Text('Help Center'),
                onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HelpPage()),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout), // Add icon
                title: const Text('Logout'), // Added logout button
                onTap: () {
                  _showLogoutConfirmationDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(currentIndex: _currentIndex), // Use the custom navbar
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () async {
                await box.remove('email');
                await box.remove('password');
                await box.remove('fullName');
                await box.remove('phoneNumber');
                await box.remove('saldo');

                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const OnBoarding()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
