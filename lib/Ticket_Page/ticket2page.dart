import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:myapp/Ticket_Page/eticketpage.dart';

class TicketOnly2Page extends StatefulWidget {
  const TicketOnly2Page({super.key});

  @override
  _TicketOnly2PageState createState() => _TicketOnly2PageState();
}

class _TicketOnly2PageState extends State<TicketOnly2Page>
    with SingleTickerProviderStateMixin {
  DateTime _selectedDate = DateTime.now();
  int _selectedTickets = 1;
  int _selectedMonth = DateTime.now().month;
  bool _isDateSelected = false;
  late PageController _pageController;
  late TabController _tabController;
  String? _selectedBundlingOption;
  final box = GetStorage(); // GetStorage instance

  final List<String> _months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  final Map<String, int> _prices = {
    'Ticket Only': 100000,
    'Bundle Package': 150000,
  };

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    // Initialize GetStorage
    GetStorage.init();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _savePurchaseHistory(
      String email, String title, String date, int totalPrice) async {
    final String firebaseUrl =
        'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/history.json';

    final Map<String, dynamic> purchaseHistory = {
      'email': email,
      'judul': title,
      'tanggal': date,
      'total_harga': totalPrice,
    };

    final response = await http.post(
      Uri.parse(firebaseUrl),
      body: jsonEncode(purchaseHistory),
    );

    if (response.statusCode == 200) {
      print('Purchase history saved successfully.');
    } else {
      print('Failed to save purchase history. Error: ${response.statusCode}');
    }
  }

  Future<bool> _handlePurchase(String ticketType) async {
    final String email = box.read('email');
    final int totalPrice = _prices[ticketType]! * _selectedTickets;
    final String firebaseUrl =
        'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/users.json';

    // Fetch user balance from Firebase
    final response = await http.get(Uri.parse(firebaseUrl));
    if (response.statusCode == 200) {
      final Map<String, dynamic> usersData = jsonDecode(response.body);
      int currentBalance = 0;
      String userId = '';

      usersData.forEach((key, value) {
        if (value['email'] == email) {
          currentBalance = value['saldo'];
          userId = key;
        }
      });

      if (currentBalance >= totalPrice) {
        // Deduct balance and update in Firebase
        final newBalance = currentBalance - totalPrice;
        final updateResponse = await http.patch(
          Uri.parse(
              'https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/users/$userId.json'),
          body: jsonEncode({'saldo': newBalance}),
        );

        if (updateResponse.statusCode == 200) {
          // Save new balance to GetStorage
          box.write('saldo', newBalance);
          // Save purchase history
          await _savePurchaseHistory(
            email,
            '$_selectedTickets Ticket Jatim Park 2',
            '${_selectedDate.day}-${_selectedDate.month}-${_selectedDate.year}',
            totalPrice,
          );
          return true;
        }
      }
    }
    return false;
  }

  void _selectDate(int day, String ticketType) {
    setState(() {
      _selectedDate = DateTime(_selectedDate.year, _selectedMonth, day);
      _isDateSelected = true;
    });
    _showBottomSheet(ticketType);
  }

  void _showBottomSheet(String ticketType) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Jatim Park 2',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      if (ticketType == 'Bundle Package') ...[
                        const Text(
                          'Select Additional Bundling Options:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RadioListTile(
                              title: const Text('Bundle 1'),
                              value: 'KF + Fastrack',
                              groupValue: _selectedBundlingOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBundlingOption = value as String;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text('Bundle 2'),
                              value: 'Other Bundling Option',
                              groupValue: _selectedBundlingOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBundlingOption = value as String;
                                });
                              },
                            ),
                            RadioListTile(
                              title: const Text('Bundle 3'),
                              value: 'Another Bundling Option',
                              groupValue: _selectedBundlingOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedBundlingOption = value as String;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                      ],
                      const Text(
                        'Select number of tickets:',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                if (_selectedTickets > 1) {
                                  _selectedTickets--;
                                }
                              });
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('$_selectedTickets'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _selectedTickets++;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Total Price: Rp. ${_prices[ticketType]! * _selectedTickets}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          bool success = await _handlePurchase(ticketType);
                          if (success) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ETicketPage(
                                  ticketType: _tabController.index == 0
                                      ? 'Ticket Only'
                                      : 'Bundle Package',
                                  selectedTickets: _selectedTickets,
                                  selectedDate: _selectedDate,
                                  selectedBundlingOption: _selectedBundlingOption,
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Insufficient balance!'),
                              ),
                            );
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCalendar(String ticketType) {
    int daysInMonth = DateTime(_selectedDate.year, _selectedMonth + 1, 0).day;
    int firstWeekdayOfMonth =
        DateTime(_selectedDate.year, _selectedMonth, 1).weekday;

    List<TableRow> calendarRows = [];
    List<Widget> rowChildren = [];

    // Fill the first row with empty cells if the month does not start on Monday
    for (int i = 1; i < firstWeekdayOfMonth; i++) {
      rowChildren.add(Container());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      rowChildren.add(_buildCalendarCell(day, ticketType));
      if (rowChildren.length == 7) {
        calendarRows.add(TableRow(children: List.from(rowChildren)));
        rowChildren.clear();
      }
    }

    // Fill the last row with empty cells if it does not end on Sunday
    if (rowChildren.isNotEmpty) {
      while (rowChildren.length < 7) {
        rowChildren.add(Container());
      }
      calendarRows.add(TableRow(children: rowChildren));
    }

    return Table(children: calendarRows);
  }

  Widget _buildCalendarCell(int date, String ticketType) {
    return InkWell(
      onTap: () {
        _selectDate(date, ticketType);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(date.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketOption(String option) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Month',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        DropdownButton<int>(
          value: _selectedMonth,
          items: List.generate(
            12,
            (index) => DropdownMenuItem(
              value: index + 1,
              child: Text(_months[index]),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _selectedMonth = value!;
              _isDateSelected = false;
            });
          },
        ),
        const SizedBox(height: 24.0),
        const Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16.0),
        _buildCalendar(option),
        const SizedBox(height: 24.0),
        if (_isDateSelected)
          ElevatedButton(
            onPressed: () async {
              bool success = await _handlePurchase(option);
              if (success) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ETicketPage(
                      ticketType: _tabController.index == 0
                          ? 'Ticket Only'
                          : 'Bundle Package',
                      selectedTickets: _selectedTickets,
                      selectedDate: _selectedDate,
                      selectedBundlingOption: _selectedBundlingOption,
                    ),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Insufficient balance!'),
                  ),
                );
              }
            },
            child: const Text('Submit'),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_tabController.length == 2) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ticket'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Image.asset(
                        'assets/img/jatim2.jpg',
                        height: 100,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jatim Park 2',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Jl. Oro-oro Ombo No. 9, Kecamatan Batu, Malang, Jawa Timur',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  tabs: const [
                    Tab(
                      text: 'Ticket Only',
                    ),
                    Tab(
                      text: 'Bundle Package',
                    ),
                  ],
                ),
                SizedBox(
                  height: 500,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildTicketOption('Ticket Only'),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _buildTicketOption('Bundle Package'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}