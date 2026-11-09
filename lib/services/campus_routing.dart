import 'package:latlong2/latlong.dart';

/// Shortest walking route over the campus walkway graph (Dijkstra).
class CampusRouter {
  final Map<String, LatLng> nodes;
  final Map<String, Map<String, double>> _adj = {};
  static const _dist = Distance();

  CampusRouter(this.nodes, List<List<String>> edges) {
    for (final e in edges) {
      final a = e[0], b = e[1];
      if (!nodes.containsKey(a) || !nodes.containsKey(b)) continue;
      final d = _dist(nodes[a]!, nodes[b]!);
      _adj.putIfAbsent(a, () => {})[b] = d;
      _adj.putIfAbsent(b, () => {})[a] = d;
    }
  }

  /// Returns the route as points plus its length in metres, or null if unreachable.
  ({List<LatLng> points, double metres})? route(String from, String to) {
    if (!nodes.containsKey(from) || !nodes.containsKey(to)) return null;
    if (from == to) return (points: [nodes[from]!], metres: 0);
    final dist = <String, double>{from: 0};
    final prev = <String, String>{};
    final open = <String>{from};
    final done = <String>{};
    while (open.isNotEmpty) {
      final u = open.reduce((a, b) => dist[a]! <= dist[b]! ? a : b);
      open.remove(u);
      if (u == to) break;
      done.add(u);
      for (final entry in (_adj[u] ?? const <String, double>{}).entries) {
        if (done.contains(entry.key)) continue;
        final nd = dist[u]! + entry.value;
        if (nd < (dist[entry.key] ?? double.infinity)) {
          dist[entry.key] = nd;
          prev[entry.key] = u;
          open.add(entry.key);
        }
      }
    }
    if (!dist.containsKey(to)) {
      // Not connected in the graph: fall back to a straight line.
      return (points: [nodes[from]!, nodes[to]!], metres: _dist(nodes[from]!, nodes[to]!));
    }
    final path = <LatLng>[];
    String? cur = to;
    while (cur != null) {
      path.insert(0, nodes[cur]!);
      cur = prev[cur];
    }
    return (points: path, metres: dist[to]!);
  }
}
