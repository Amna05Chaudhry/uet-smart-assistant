import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_assistant_uni/services/campus_routing.dart';

void main() {
  group('CampusRouter', () {
    final nodes = {
      'a': const LatLng(32.0, 74.0),
      'b': const LatLng(32.001, 74.0),
      'c': const LatLng(32.002, 74.0),
      'd': const LatLng(32.0, 74.01), // far detour
    };
    final router = CampusRouter(nodes, [
      ['a', 'b'],
      ['b', 'c'],
      ['a', 'd'],
      ['d', 'c'],
    ]);

    test('finds the shortest path through the walkway graph', () {
      final r = router.route('a', 'c')!;
      expect(r.points, [nodes['a'], nodes['b'], nodes['c']]);
      expect(r.metres, closeTo(222, 3)); // 0.002 deg latitude ~ 222 m
    });

    test('same start and end gives a zero-length route', () {
      expect(router.route('b', 'b')!.metres, 0);
    });

    test('unknown node returns null', () {
      expect(router.route('a', 'zzz'), isNull);
    });
  });
}
