import 'package:flutter/material.dart';

/// The quick cards on the Home screen. Each one opens a topic page built from the
/// FAQ category of the same name, plus a few key facts.
class Topic {
  final String id, title, subtitle, faqCategory;
  final IconData icon;
  final Color color;
  final List<(IconData, String)> facts;
  final String? building;

  const Topic(this.id, this.title, this.subtitle, this.icon, this.color, this.faqCategory,
      {this.facts = const [], this.building});
}

const topics = <Topic>[
  Topic('departments', 'Departments', 'Programmes, labs and faculty',
      Icons.school_rounded, Color(0xFF4F46E5), 'Departments'),
  Topic('hostels', 'Hostels', 'Rooms, mess and rules', Icons.bed_rounded,
      Color(0xFF0EA5E9), 'Hostels',
      building: 'boys_hostel',
      facts: [
        (Icons.payments_outlined, 'About Rs. 15,000 / semester + mess (sample)'),
        (Icons.schedule, 'In-time: 10:30 pm boys, 9:00 pm girls (sample)'),
        (Icons.wifi, 'Wi-Fi, mess, common room'),
      ]),
  Topic('admissions', 'Admissions', 'ECAT, merit and documents',
      Icons.assignment_turned_in_rounded, Color(0xFF10B981), 'Admissions',
      building: 'admin',
      facts: [
        (Icons.calculate_outlined, 'Merit: Matric 17% + FSc 50% + ECAT 33%'),
        (Icons.event_outlined, 'Usually opens in July (sample)'),
        (Icons.language, 'Apply on the UET Lahore admission portal'),
      ]),
  Topic('fees', 'Fee & Scholarships', 'Fee structure and financial aid',
      Icons.account_balance_wallet_rounded, Color(0xFFF59E0B), 'Fees & Scholarships',
      building: 'admin',
      facts: [
        (Icons.payments_outlined, 'About Rs. 58-62k per semester (sample)'),
        (Icons.volunteer_activism_outlined, 'Ehsaas, PEEF and merit scholarships'),
        (Icons.receipt_long_outlined, 'Pay by bank challan or 1Bill'),
      ]),
  Topic('transport', 'Transport', 'Bus routes, timings and passes',
      Icons.directions_bus_rounded, Color(0xFFEF4444), 'Transport',
      building: 'parking',
      facts: [
        (Icons.route_outlined, 'Narowal, Shakargarh, Zafarwal, Pasrur, Sialkot (sample)'),
        (Icons.schedule, 'Return buses 2:30 pm and 4:30 pm (sample)'),
        (Icons.credit_card, 'Semester bus pass ~ Rs. 9,000 (sample)'),
      ]),
  Topic('events', 'Events', 'Societies, fests and dates', Icons.celebration_rounded,
      Color(0xFFEC4899), 'Events & Societies',
      building: 'auditorium'),
  Topic('academics', 'Exams & Grading', 'GPA, attendance, transcripts',
      Icons.menu_book_rounded, Color(0xFF8B5CF6), 'Academics & Exams'),
  Topic('facilities', 'Campus Facilities', 'Library, cafe, sports, Wi-Fi',
      Icons.local_library_rounded, Color(0xFF14B8A6), 'Campus Facilities',
      building: 'library'),
];
