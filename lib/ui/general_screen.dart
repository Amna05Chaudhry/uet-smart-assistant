import 'package:flutter/material.dart';
import '../cards/hostel_registration_card.dart';
import '../cards/info_card.dart';
import '../cards/departments_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: GridView.count(
          primary: false,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: const [
            HostelRegistrationCard(),
            InformationCard(),
            DepartmentsCard(),
          ],
        ),
      ),
    );
  }
}
