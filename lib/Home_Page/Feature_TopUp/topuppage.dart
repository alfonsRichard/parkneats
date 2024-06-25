import 'package:flutter/material.dart';
import 'neareststore.dart';
import 'atm.dart';
import 'mobilebanking.dart';
import 'package:get_storage/get_storage.dart';

class TopUpPage extends StatelessWidget {
  const TopUpPage({super.key});

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Top Up'),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Balance',
                    style: TextStyle(
                            fontSize: 20, // Adjusted text size
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
                      SizedBox(width: 5),
                      Text(
                        '${formatRupiah(box.read('saldo') ?? 0)}',
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
              'Pilih Metode',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: <Widget>[
                  TopUpMethodCard(
                    icon: Icons.phone_android,
                    title: 'Mobile Banking',
                    description: 'Use your mobile banking app',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MobileBankingPage()),
                      );
                    },
                  ),
                  TopUpMethodCard(
                    icon: Icons.account_balance,
                    title: 'ATM',
                    description: 'Use an ATM machine with a Virtual Account code',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ATMPage()),
                      );
                    },
                  ),
                  TopUpMethodCard(
                    icon: Icons.store,
                    title: 'Nearest Store',
                    description: 'Indomaret, Alfamart, Alfamidi, Lawson, etc',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NearestStorePage()),
                      );
                    },
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

class TopUpMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const TopUpMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Icon(icon, size: 40, color: const Color.fromARGB(255, 97, 94, 252)),
              const SizedBox(width: 20),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 5),
                    Text(description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
