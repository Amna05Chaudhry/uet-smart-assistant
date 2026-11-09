import 'package:flutter/material.dart';

class HostelRegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hostel Registration'),
      ),
      body: Center(
        child: Text(
          'This is idrees pathi hostel wala',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
