import 'package:flutter/material.dart';

class DepartmentsCard extends StatelessWidget {
  const DepartmentsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.school, size: 40, color: Colors.brown),
            SizedBox(height: 10),
            Text('Acedemia', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text('Explore academic programs and know about faculty.'),
            ),
          ],
        ),
      ),
    );
  }
}
