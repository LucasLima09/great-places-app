import "dart:convert";

import "package:http/http.dart" as http;
import "package:latlong2/latlong.dart";

const GEOAPIFY_API_KEY = 'COLOQUE_SUA_API_KEY_AQUI';

class LocationUtil {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.geoapify.com/v1/staticmap?style=osm-carto'
        '&width=600&height=300&center=lonlat:$longitude,$latitude'
        '&marker=lonlat:$longitude,$latitude;color:%23ff0000;size:medium'
        '&zoom=13&apiKey=$GEOAPIFY_API_KEY';
  }

  static Future<String> getAdressFrom(LatLng position) async {
    final url =
        'https://api.geoapify.com/v1/geocode/reverse?lat=${position.latitude}&lon=${position.longitude}&apiKey=$GEOAPIFY_API_KEY';
    final response = await http.get(Uri.parse(url));
    final parsed = jsonDecode(response.body);

    if (parsed['features'] == null || parsed['features'].isEmpty) {
      return "Endereço desconhecido";
    }

    return parsed['features'][0]['properties']['formatted'];
  }
}
