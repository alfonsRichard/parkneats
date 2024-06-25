import 'package:flutter/material.dart';
import 'topupsuccess.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:url_launcher/url_launcher_string.dart';

class NearestStorePage extends StatelessWidget {
  NearestStorePage({super.key});

  final TextEditingController _amountController = TextEditingController();

  Future<void> createPaymentLink({
    required String type,
    required int amount,
    required BuildContext context, // Add context to the parameters
  }) async {
    String uuid = Uuid().v4();
    final shortUuid = uuid.substring(0, 5);
    final url = Uri.parse('https://api.sandbox.midtrans.com/v1/payment-links');

    // Hit the temporary_saldo endpoint
    final box = GetStorage();
    final email = box.read('email') ?? 'default@gmail.com';
    final tempSaldoUrl = Uri.parse('https://park-n-eats-default-rtdb.asia-southeast1.firebasedatabase.app/temporary_saldo.json');

    final tempSaldoResponse = await http.post(
      tempSaldoUrl,
      body: json.encode({
        'email': email,
        'saldo': amount,
        'shortUuid': shortUuid,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (tempSaldoResponse.statusCode == 200) {
      print('temporary_saldo updated successfully');
    } else {
      print('Failed to update temporary_saldo: ${tempSaldoResponse.statusCode}');
    }

    List<String> enabledPayments = [];

    if (type == 'nearestStore') {
      enabledPayments = ['indomaret'];
    } else if (type == 'atm' || type == 'mobileBanking') {
      enabledPayments = [
        'permata_va',
        'other_va',
        'bca_va',
        'bni_va',
        'bri_va'
      ];
    }
    print(amount);
    final response = await http.post(url,
        body: json.encode({
          "transaction_details": {
            "order_id": "${shortUuid}",
            "gross_amount": amount
          },
          "usage_limit": 3,
          "enabled_payments": enabledPayments
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Basic U0ItTWlkLXNlcnZlci1fUG11LWlGaDRLOGdaaW5UZlExb0pPTXM6'
        });

    print(json.decode(response.body));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final paymentUrl = data['payment_url'];

      if (await canLaunchUrlString(paymentUrl)) {
        await launchUrlString(paymentUrl, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $paymentUrl';
      }
    } else {
      print('Failed to create payment link: ${response.statusCode}');
    }
  }

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
        title: const Text('Nearest Store'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
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
                      Icon(Icons.account_balance_wallet,
                          color: Colors.white, size: 30),
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
            const SizedBox(
                height:
                    50), // Penambahan jarak antara saldo dan judul Top Up Nominal
            const Text(
              'Top Up Nominal',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
                height: 20), // Penambahan jarak antara judul dan input nominal
            TextField(
              controller: _amountController,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              decoration: const InputDecoration(
                labelText: 'Enter minimum top up here',
                hintText: 'Minimum Rp 10.000,00',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 100),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 97, 94, 252),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  final int amount = int.tryParse(_amountController.text) ?? 0;
                  if (amount >= 10000) {
                    createPaymentLink(
                        type: 'nearestStore', amount: amount, context: context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Minimum top-up amount is Rp 10.000,00'),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Top Up Now',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
