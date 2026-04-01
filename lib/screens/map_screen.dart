import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';

class MapScreen extends StatefulWidget {
  final LatLng initialLocation;
  final bool isReadonly;

  const MapScreen({
    this.initialLocation = const LatLng(-23.58664084252487, -46.68217336181415),
    this.isReadonly = false,
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedPosition;

  void _selectedPosition(TapPosition tapInfo, LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isReadonly ? "Localização" : "Selecione..."),
        actions: [
          if (_pickedPosition != null && !widget.isReadonly)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedPosition);
              },
              icon: Icon(Icons.check),
            ),
        ],
      ),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: widget.initialLocation,
          initialZoom: 13,
          onTap: widget.isReadonly ? null : _selectedPosition,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.seunome.great_places',
          ),
          if (_pickedPosition != null || widget.isReadonly)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: _pickedPosition ?? widget.initialLocation,
                  child: const Icon(
                    Icons.location_on,
                    size: 40,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
