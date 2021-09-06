// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'locations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

Office _$OfficeFromJson(Map<String, dynamic> json) {
  return Office(
    id: json['id'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    campus: json['campus'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'campus': instance.campus,
      'phone': instance.phone,
    };

Locations _$LocationsFromJson(Map<String, dynamic> json) {
  return Locations(
    offices: (json['offices'] as List)
        ?.map((e) =>
            e == null ? null : Office.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$LocationsToJson(Locations instance) => <String, dynamic>{
      'offices': instance.offices,
    };
