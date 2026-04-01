import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/screens/map_screen.dart';

class PlaceDetailScree extends StatelessWidget {
  const PlaceDetailScree({super.key});

  @override
  Widget build(BuildContext context) {
    final place = ModalRoute.of(context)!.settings.arguments as Place;
    return Scaffold(
      appBar: AppBar(title: Text(place.title)),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 300,
            child: Image.file(
              place.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            place.location.adress,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: Colors.grey),
          ),
          SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: place.location.toLatLng(),
                    isReadonly: true,
                  ),
                ),
              );
            },
            label: Text("Ver no mapa"),
            icon: Icon(Icons.map),
          ),
        ],
      ),
    );
  }
}
