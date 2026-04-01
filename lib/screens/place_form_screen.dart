import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/widgets/image_input.dart';
import 'package:great_places/widgets/location_input.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class PlaceFormScreen extends StatefulWidget {
  @override
  State<PlaceFormScreen> createState() => _PlaceFormScreenState();
}

class _PlaceFormScreenState extends State<PlaceFormScreen> {
  final _titleController = TextEditingController();

  File? _pickedImage;
  LatLng? _pickedPosition;

  void _selectedPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  void _selectedImage(File pickedImage) {
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  bool _isValidForm() {
    return _titleController.text.isNotEmpty &&
        _pickedImage != null &&
        _pickedPosition != null;
  }

  void _submitForm() {
    if (!_isValidForm()) {
      return;
    }

    Provider.of<GreatPlaces>(
      context,
      listen: false,
    ).addPlace(_titleController.text, _pickedImage!, _pickedPosition!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adicionar Lugar")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Título'),
                      onChanged: (text) {
                        setState(() {});
                      },
                    ),
                    SizedBox(height: 10),
                    ImageInput(this._selectedImage),
                    SizedBox(height: 10),
                    LocationInput(this._selectedPosition),
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: _isValidForm() ? _submitForm : null,
            label: Text("Adicionar"),
            icon: Icon(Icons.add),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              elevation: 0,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }
}
