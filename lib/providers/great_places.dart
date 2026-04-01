import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/utils/db_util.dart';
import 'package:great_places/utils/location_util.dart';
import 'package:latlong2/latlong.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(
              latitude: item['latitude'],
              longitude: item['longitude'],
              adress: item['address'],
            ),
            image: File(item['image']),
          ),
        )
        .toList();
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  Place itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addPlace(String title, File image, LatLng position) async {
    String adress = await LocationUtil.getAdressFrom(position);

    final newPlace = Place(
      id: Random().nextDouble().toString(),
      title: title,
      location: PlaceLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        adress: adress,
      ),
      image: image,
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
      'latitude': newPlace.location.latitude,
      'longitude': newPlace.location.longitude,
      'address': newPlace.location.adress,
    });
    notifyListeners();
  }
}
