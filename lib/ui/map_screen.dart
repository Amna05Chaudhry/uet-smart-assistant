import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../app_state.dart';
import '../models.dart';
import '../services/campus_routing.dart';

const _iconFor = {
  'gate': Icons.door_front_door_rounded,
  'admin': Icons.business_rounded,
  'library': Icons.local_library_rounded,
  'academic': Icons.school_rounded,
  'auditorium': Icons.theater_comedy_rounded,
  'food': Icons.restaurant_rounded,
  'mosque': Icons.mosque_rounded,
  'sports': Icons.sports_cricket_rounded,
  'hostel': Icons.bed_rounded,
  'medical': Icons.local_hospital_rounded,
  'bus': Icons.directions_bus_rounded,
};

const _colorFor = {
  'Academic': Color(0xFF4F46E5),
  'Administration': Color(0xFF0EA5E9),
  'Facilities': Color(0xFF14B8A6),
  'Food': Color(0xFFF59E0B),
  'Sports': Color(0xFF22C55E),
  'Hostel': Color(0xFFEC4899),
  'Transport': Color(0xFFEF4444),
  'Entrance': Color(0xFF64748B),
};

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final _map = MapController();
  AppState? _app;
  late CampusRouter _router;
  Building? _selected;
  String? _from, _to;
  ({List<LatLng> points, double metres})? _route;
  bool _directions = false;
  bool _mapReady = false;
  String? _pendingFocus;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_app == null) {
      _app = AppScope.read(context);
      _router = CampusRouter(_app!.data.pathNodes, _app!.data.pathEdges);
      _app!.focusBuilding.addListener(_onFocus);
      _onFocus();
    }
  }

  @override
  void dispose() {
    _app?.focusBuilding.removeListener(_onFocus);
    super.dispose();
  }

  void _onFocus() {
    final id = _app!.focusBuilding.value;
    if (id == null) return;
    _app!.focusBuilding.value = null;
    if (!_mapReady) {
      _pendingFocus = id;
      return;
    }
    final b = _app!.data.building(id);
    if (b != null) _select(b);
  }

  void _select(Building b, {bool move = true}) {
    setState(() => _selected = b);
    if (move && _mapReady) _map.move(b.point, 18);
  }

  void _computeRoute() {
    if (_from == null || _to == null) return;
    final r = _router.route(_from!, _to!);
    setState(() => _route = r);
    if (r != null && r.points.length > 1) {
      _map.fitCamera(CameraFit.coordinates(
          coordinates: r.points, padding: const EdgeInsets.fromLTRB(60, 200, 60, 260)));
    }
  }

  void _directionsTo(Building b) {
    setState(() {
      _directions = true;
      _to = b.id;
      if (_from == null || _from == b.id) _from = b.id == 'gate' ? 'parking' : 'gate';
    });
    _computeRoute();
  }

  @override
  Widget build(BuildContext context) {
    final data = _app!.data;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(children: [
        FlutterMap(
          mapController: _map,
          options: MapOptions(
            initialCenter: data.center,
            initialZoom: data.zoom,
            minZoom: 14,
            maxZoom: 19,
            onTap: (_, __) => setState(() => _selected = null),
            onMapReady: () {
              _mapReady = true;
              if (_pendingFocus != null) {
                final b = data.building(_pendingFocus!);
                _pendingFocus = null;
                if (b != null) _select(b);
              }
            },
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'pk.edu.uet.narowal.smart_assistant',
              tileBuilder: dark ? _darkTiles : null,
            ),
            if (_route != null)
              PolylineLayer(polylines: [
                Polyline(
                  points: _route!.points,
                  strokeWidth: 6,
                  color: scheme.primary,
                  borderStrokeWidth: 2,
                  borderColor: Colors.white,
                ),
              ]),
            MarkerLayer(markers: [
              for (final b in data.buildings)
                Marker(
                  point: b.point,
                  width: 120,
                  height: 64,
                  alignment: Alignment.topCenter,
                  child: _Pin(
                    building: b,
                    selected: _selected?.id == b.id || b.id == _from || b.id == _to,
                    onTap: () => _select(b, move: false),
                  ),
                ),
            ]),
            const RichAttributionWidget(attributions: [
              TextSourceAttribution('OpenStreetMap contributors'),
            ]),
          ],
        ),
        SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  _directions ? _directionsPanel(data) : _searchBox(data),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Building positions are approximate placeholders',
                        style: TextStyle(fontSize: 11, color: Colors.brown.shade800)),
                  ),
                ]),
              ),
            ),
          ),
        ),
        Positioned(
          right: 16,
          bottom: _selected != null ? 190 : 24,
          child: Column(children: [
            FloatingActionButton.small(
              heroTag: 'recenter',
              tooltip: 'Recenter campus',
              onPressed: () => _map.move(data.center, data.zoom),
              child: const Icon(Icons.center_focus_strong_rounded),
            ),
            const SizedBox(height: 8),
            FloatingActionButton.extended(
              heroTag: 'dir',
              onPressed: () => setState(() {
                _directions = !_directions;
                if (!_directions) _route = null;
              }),
              icon: Icon(_directions ? Icons.close : Icons.directions_rounded),
              label: Text(_directions ? 'Close' : 'Directions'),
            ),
          ]),
        ),
        if (_selected != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _InfoCard(
                  building: _selected!,
                  onDirections: () => _directionsTo(_selected!),
                  onClose: () => setState(() => _selected = null),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  Widget _searchBox(CampusData data) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(28),
      color: Theme.of(context).colorScheme.surface,
      child: Autocomplete<Building>(
        displayStringForOption: (b) => b.name,
        optionsBuilder: (v) {
          final q = v.text.toLowerCase().trim();
          if (q.isEmpty) return const Iterable<Building>.empty();
          return data.buildings.where((b) =>
              b.name.toLowerCase().contains(q) ||
              b.category.toLowerCase().contains(q) ||
              b.description.toLowerCase().contains(q));
        },
        onSelected: (b) {
          FocusScope.of(context).unfocus();
          _select(b);
        },
        fieldViewBuilder: (context, ctrl, focus, onSubmit) => TextField(
          controller: ctrl,
          focusNode: focus,
          onSubmitted: (_) => onSubmit(),
          decoration: InputDecoration(
            hintText: 'Search buildings, e.g. library, hostel, CS',
            prefixIcon: const Icon(Icons.search_rounded),
            fillColor: Theme.of(context).colorScheme.surface,
            suffixIcon: IconButton(
                icon: const Icon(Icons.clear), onPressed: () => ctrl.clear()),
          ),
        ),
        optionsViewBuilder: (context, onSelected, options) => Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 280, maxWidth: 536),
              child: ListView(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                children: [
                  for (final b in options)
                    ListTile(
                      leading: Icon(_iconFor[b.icon] ?? Icons.place,
                          color: _colorFor[b.category]),
                      title: Text(b.name),
                      subtitle: Text(b.category),
                      onTap: () => onSelected(b),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _directionsPanel(CampusData data) {
    final theme = Theme.of(context);
    final sorted = [...data.buildings]..sort((a, b) => a.name.compareTo(b.name));
    DropdownMenuItem<String> item(Building b) => DropdownMenuItem(
        value: b.id, child: Text(b.name, overflow: TextOverflow.ellipsis));
    Widget pick(String label, IconData icon, String? value, ValueChanged<String?> onChanged) =>
        DropdownButtonFormField<String>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          items: [for (final b in sorted) item(b)],
          onChanged: onChanged,
        );
    final minutes = _route == null ? 0 : (_route!.metres / 80).ceil(); // ~80 m/min walking

    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          pick('From', Icons.trip_origin, _from, (v) {
            setState(() => _from = v);
            _computeRoute();
          }),
          const SizedBox(height: 8),
          pick('To', Icons.place_rounded, _to, (v) {
            setState(() => _to = v);
            _computeRoute();
          }),
          if (_route != null) ...[
            const SizedBox(height: 10),
            Row(children: [
              Icon(Icons.directions_walk_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('${_route!.metres.round()} m',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(width: 8),
              Text('about $minutes min walk', style: theme.textTheme.bodyMedium),
            ]),
          ],
        ]),
      ),
    );
  }
}

Widget _darkTiles(BuildContext context, Widget tile, TileImage image) {
  // Invert + hue-rotate the OSM tiles for a readable dark map.
  return ColorFiltered(
    colorFilter: const ColorFilter.matrix(<double>[
      -0.574, -1.43, -0.144, 0, 255, //
      -0.426, -1.43, -0.144, 0, 255, //
      -0.426, -1.43, 0.856, 0, 255, //
      0, 0, 0, 1, 0,
    ]),
    child: tile,
  );
}

class _Pin extends StatelessWidget {
  const _Pin({required this.building, required this.selected, required this.onTap});
  final Building building;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorFor[building.category] ?? Colors.indigo;
    final size = selected ? 40.0 : 32.0;
    final short = building.name.split(' (').first;
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: selected ? 3 : 2),
            boxShadow: const [BoxShadow(blurRadius: 6, color: Colors.black26)],
          ),
          child: Icon(_iconFor[building.icon] ?? Icons.place, color: Colors.white, size: size * .55),
        ),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .9),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(short,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)),
        ),
      ]),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.building, required this.onDirections, required this.onClose});
  final Building building;
  final VoidCallback onDirections, onClose;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _colorFor[building.category] ?? theme.colorScheme.primary;
    return Card(
      elevation: 4,
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            CircleAvatar(
                backgroundColor: color.withValues(alpha: .15),
                child: Icon(_iconFor[building.icon] ?? Icons.place, color: color)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(building.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(building.category,
                    style: theme.textTheme.labelMedium?.copyWith(color: color)),
              ]),
            ),
            IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 8),
          Text(building.description, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: onDirections,
            icon: const Icon(Icons.directions_walk_rounded, size: 18),
            label: const Text('Directions here'),
          ),
        ]),
      ),
    );
  }
}
