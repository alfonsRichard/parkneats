import 'package:flutter/material.dart';
import 'package:myapp/Home_Page/homepage.dart';
import 'package:myapp/Order_Page/orderpage.dart';
import 'package:myapp/Ticket_Page/ticketpage.dart';
import 'package:myapp/Account_Page/accountpage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavigationBar({required this.currentIndex, super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      unselectedItemColor: Colors.black,
      selectedItemColor: const Color.fromARGB(255, 97, 94, 252),
      unselectedLabelStyle: const TextStyle(color: Colors.black),
      selectedLabelStyle: const TextStyle(color: Color.fromARGB(255, 97, 94, 252)),
      selectedIconTheme: const IconThemeData(color: Color.fromARGB(255, 97, 94, 252)),
      unselectedIconTheme: const IconThemeData(color: Colors.black),
      showUnselectedLabels: true, // Menampilkan label untuk item yang tidak dipilih
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.confirmation_num),
          label: 'Ticket',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.food_bank),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
        ),
      ],
      onTap: (index) {
        if (index != currentIndex) {
          if (index == 0) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const TicketPage()),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const OrderPage()),
            );
          } else if (index == 3) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const AccountPage()),
            );
          }
        }
      },
    );
  }
}
