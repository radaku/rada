import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

part 'locations.g.dart';

@JsonSerializable()
class LatLng {
  LatLng({
    this.latitude,
    this.longitude,
  });

  factory LatLng.fromJson(Map<String, dynamic> json) => _$LatLngFromJson(json);
  Map<String, dynamic> toJson() => _$LatLngToJson(this);

  final double latitude;
  final double longitude;
}


@JsonSerializable()
class Office {
  Office({
    this.id,
    this.latitude,
    this.longitude,
    this.campus,
    this.phone,
  });

  factory Office.fromJson(Map<String, dynamic> json) => _$OfficeFromJson(json);
  Map<String, dynamic> toJson() => _$OfficeToJson(this);

  final String id;
  final double latitude;
  final double longitude;
  final String campus;
  final String phone;
}

@JsonSerializable()
class Locations {
  Locations({
    this.offices,
  });

  factory Locations.fromJson(Map<String, dynamic> json) =>
      _$LocationsFromJson(json);
  Map<String, dynamic> toJson() => _$LocationsToJson(this);

  final List<Office> offices;
}

Future<Locations> getGoogleOffices() async {
  const googleLocationsURL = 'http://rada.uonbi.ac.ke/radaweb/api/locations/get';
  // Retrieve the locations of Google offices
  final response = await http.get(googleLocationsURL);
  //print(response.body);
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
            ' ${response.reasonPhrase}',
        uri: Uri.parse(googleLocationsURL));
  }
}