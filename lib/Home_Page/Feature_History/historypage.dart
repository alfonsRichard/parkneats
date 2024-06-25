import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<HistoryItem> _historyItems = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

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

  Future<void> _fetchHistory() async {
    final historyUrl = Uri.parse(
        'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/history.json');
    final usersUrl = Uri.parse(
        'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/users.json');
    try {
      // Fetch user data and store in local storage
      final usersResponse = await http.get(usersUrl);
      if (usersResponse.statusCode == 200) {
        final userData = json.decode(usersResponse.body) as Map<String, dynamic>;
        final box = GetStorage();
        userData.forEach((key, value) {
          if (value['email'] == box.read('email')) {
            box.write('fullName', value['fullName']);
            box.write('phoneNumber', value['phoneNumber']);
            box.write('email', value['email']);
            box.write('password', value['password']);
            box.write('saldo', value['saldo']);
          }
        });
      } else {
        throw Exception('Failed to load user data');
      }

      // Fetch history data and display
      final historyResponse = await http.get(historyUrl);
      if (historyResponse.statusCode == 200) {
        final box = GetStorage();
        final email = box.read('email');
        final data = json.decode(historyResponse.body) as Map<String, dynamic>;
        final List<HistoryItem> loadedHistory = [];
        data.forEach((key, value) {
          if (value['email'] == email) {
            loadedHistory.add(HistoryItem(
              title: value['judul'],
              date: value['tanggal'],
              price: '${formatRupiah(value['total_harga'])}',
            ));
          }
        });
        setState(() {
          _historyItems = loadedHistory;
        });
      } else {
        throw Exception('Failed to load history');
      }
    } catch (error) {
      print('Error fetching history: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('History'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: _historyItems.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Your History',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ..._historyItems.map((item) {
                      return HistoryItemWidget(
                        title: item.title,
                        date: item.date,
                        price: item.price,
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
    );
  }
}

class HistoryItem {
  final String title;
  final String date;
  final String price;

  HistoryItem({
    required this.title,
    required this.date,
    required this.price,
  });
}

class HistoryItemWidget extends StatelessWidget {
  final String title;
  final String date;
  final String price;

  const HistoryItemWidget({
    super.key,
    required this.title,
    required this.date,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'See detail',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 97, 94, 252),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
