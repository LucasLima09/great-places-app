import 'package:flutter/material.dart';
import 'package:great_places/screens/map_screen.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationInput extends StatefulWidget {
  final Function(LatLng) onSelectedPosition;

  const LocationInput(this.onSelectedPosition, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double long) {
    final staticMapUrl = LocationUtil.generateLocationPreviewImage(
      latitude: lat,
      longitude: long,
    );

    setState(() {
      _previewImageUrl = staticMapUrl;
    });
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    final myLocation = LatLng(locData.latitude!, locData.longitude!);

    final LatLng? selectedPosition = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(initialLocation: myLocation),
      ),
    );
    if (selectedPosition == null) return;

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);

    widget.onSelectedPosition(selectedPosition);
  }

  Future<void> _getCurrentUserLocation() async {

    final locData = await Location().getLocation();



    _showPreview(locData.latitude!, locData.longitude!);



    final convertLatLng = LatLng(locData.latitude!, locData.longitude!);

    widget.onSelectedPosition(convertLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _previewImageUrl == null
              ? Text("Nenhuma localização")
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              label: Text("Localização atual"),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: Text("Selecionar no mapa"),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
