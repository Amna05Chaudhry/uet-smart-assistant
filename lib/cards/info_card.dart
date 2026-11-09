import 'package:flutter/material.dart';

class InformationCard extends StatelessWidget {
  const InformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.info_outline,
                size: 40, color: Colors.blue), // Informative icon
            SizedBox(height: 10),
            Text('Information Hub',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child:
                  Text('Essential resources and updates at your fingertips.'),
            ),
          ],
        ),
      ),
    );
  }
}
