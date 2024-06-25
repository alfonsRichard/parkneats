import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Help Center'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Help Center',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              ExpansionTile(
                leading: Icon(Icons.account_circle_outlined),
                title: Text('Account Issues'),
                subtitle: Text('Help with login, account settings, and more.'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'If you are experiencing issues with your account, such as login problems or difficulty changing account settings, please follow these steps:\n\n'
                      '1. Ensure that your internet connection is stable.\n'
                      '2. Verify that you are using the correct email and password.\n'
                      '3. If you forgot your password, use the "Forgot Password" feature to reset it.\n'
                      '4. If the issue persists, contact our support team for further assistance.'
                    ),
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.payment_outlined),
                title: Text('Payment Issues'),
                subtitle: Text('Help with payments, billing, and refunds.'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'For issues related to payments, billing, or refunds, please follow these steps:\n\n'
                      '1. Verify that your payment method is valid and has sufficient funds.\n'
                      '2. Check if there are any errors in the billing information provided.\n'
                      '3. If a payment failed, try using a different payment method.\n'
                      '4. For refund requests, contact our support team with your order details.'
                    ),
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.shopping_cart_outlined),
                title: Text('Order Issues'),
                subtitle: Text('Help with orders, deliveries, and returns.'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'If you are facing issues with orders, deliveries, or returns, please follow these steps:\n\n'
                      '1. Ensure that your shipping address is correct and complete.\n'
                      '2. Check the estimated delivery time and track your order status.\n'
                      '3. For issues with the received order, contact our support team with details of the problem.\n'
                      '4. To initiate a return, follow the return policy guidelines provided in the app.'
                    ),
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.settings),
                title: Text('Technical Support'),
                subtitle: Text('Help with app performance and bugs.'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'If you need technical support with app performance or bugs, please follow these steps:\n\n'
                      '1. Restart the app and your device to see if the issue is resolved.\n'
                      '2. Ensure that you have the latest version of the app installed.\n'
                      '3. Clear the app cache and data if the problem persists.\n'
                      '4. Contact our technical support team with details of the issue and any error messages received.'
                    ),
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.contact_support_outlined),
                title: Text('Contact Us'),
                subtitle: Text('Get in touch with our support team.'),
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'To contact our support team, please use the following methods:\n\n'
                      '1. Email: support@myapp.com\n'
                      '2. Phone: +1 234 567 890\n'
                      '3. Live Chat: Available on our website and app during business hours\n\n'
                      'Our support team is available 24/7 to assist you with any issues or inquiries.'
                    ),
                  ),
                ],
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
