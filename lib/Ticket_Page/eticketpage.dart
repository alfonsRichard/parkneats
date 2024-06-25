import 'package:flutter/material.dart';

class ETicketPage extends StatelessWidget {
  final String ticketType;
  final int selectedTickets;
  final DateTime selectedDate;
  final String? selectedBundlingOption;

  const ETicketPage({
    super.key,
    required this.ticketType,
    required this.selectedTickets,
    required this.selectedDate,
    this.selectedBundlingOption,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Ticket'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/img/jatim2.jpg'), // Ganti dengan path image yang sesuai
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: Text(
                    'Jatim Park 1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(1.0, 1.0),
                          blurRadius: 3.0,
                          color: Color.fromARGB(150, 0, 0, 0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'E-Ticket Details',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    'Ticket Type: $ticketType',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Selected Date: ${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  Text(
                    'Number of Tickets: $selectedTickets',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  if (ticketType == 'Bundle Package' &&
                      selectedBundlingOption != null)
                    Text(
                      'Bundling Option: $selectedBundlingOption',
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      // Logika untuk mencetak tiket bisa ditempatkan di sini
                      print('Printing e-ticket...');
                      // Navigasi kembali ke halaman sebelumnya
                      Navigator.pop(context);
                    },
                    child: const Text('Print E-Ticket'),
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
