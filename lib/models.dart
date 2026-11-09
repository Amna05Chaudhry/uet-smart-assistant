import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:latlong2/latlong.dart';

class FaqItem {
  final int id;
  final String category;
  final String question;
  final List<String> alternatives;
  final String answer;

  FaqItem.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        category = j['category'],
        question = j['question'],
        alternatives = List<String>.from(j['alternatives'] ?? const []),
        answer = j['answer'];
}

class Building {
  final String id;
  final String name;
  final String category;
  final String icon;
  final LatLng point;
  final String description;

  Building.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        category = j['category'],
        icon = j['icon'],
        point = LatLng((j['lat'] as num).toDouble(), (j['lng'] as num).toDouble()),
        description = j['description'];
}

class Department {
  final String id, name, short, degree, building, accreditation, chair, email, about;
  final int seats;
  final List<String> highlights, labs, careers;

  Department.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name'],
        short = j['short'],
        degree = j['degree'],
        building = j['building'],
        accreditation = j['accreditation'],
        chair = j['chair'],
        email = j['email'],
        about = j['about'],
        seats = j['seats'],
        highlights = List<String>.from(j['highlights']),
        labs = List<String>.from(j['labs']),
        careers = List<String>.from(j['careers']);
}

class CampusEvent {
  final String title, place, building, about;
  final DateTime date;

  CampusEvent.fromJson(Map<String, dynamic> j)
      : title = j['title'],
        place = j['place'],
        building = j['building'],
        about = j['about'],
        date = DateTime.parse(j['date']);
}

/// Everything the app reads from the bundled `data/*.json` files.
class CampusData {
  final List<FaqItem> faq;
  final List<Building> buildings;
  final LatLng center;
  final double zoom;
  final Map<String, LatLng> pathNodes;
  final List<List<String>> pathEdges;
  final List<Department> departments;
  final List<CampusEvent> events;

  CampusData._(this.faq, this.buildings, this.center, this.zoom, this.pathNodes,
      this.pathEdges, this.departments, this.events);

  Building? building(String id) {
    for (final b in buildings) {
      if (b.id == id) return b;
    }
    return null;
  }

  List<FaqItem> faqIn(String category) =>
      faq.where((f) => f.category == category).toList();

  static Future<CampusData> load() async {
    Future<Map<String, dynamic>> read(String p) async =>
        jsonDecode(await rootBundle.loadString(p)) as Map<String, dynamic>;
    final f = await read('data/faq.json');
    final b = await read('data/buildings.json');
    final d = await read('data/departments.json');
    final e = await read('data/events.json');

    final buildings =
        (b['buildings'] as List).map((x) => Building.fromJson(x)).toList();
    final nodes = <String, LatLng>{for (final x in buildings) x.id: x.point};
    for (final j in b['paths']['junctions'] as List) {
      nodes[j['id']] =
          LatLng((j['lat'] as num).toDouble(), (j['lng'] as num).toDouble());
    }
    final c = b['center'] as List;
    final events = (e['events'] as List).map((x) => CampusEvent.fromJson(x)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    return CampusData._(
      (f['items'] as List).map((x) => FaqItem.fromJson(x)).toList(),
      buildings,
      LatLng((c[0] as num).toDouble(), (c[1] as num).toDouble()),
      (b['zoom'] as num).toDouble(),
      nodes,
      (b['paths']['edges'] as List).map((x) => List<String>.from(x)).toList(),
      (d['departments'] as List).map((x) => Department.fromJson(x)).toList(),
      events,
    );
  }
}
