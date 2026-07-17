import 'package:cloud_firestore/cloud_firestore.dart';

/// Converts raw Firestore document data to/from JSON-safe structures for the
/// backup file, and back again on restore.
///
/// Firestore hands back native value types ([Timestamp], [GeoPoint],
/// [DocumentReference], [Blob]) that `jsonEncode` cannot serialise. Each is
/// wrapped in a tagged map under the reserved [_typeKey]; everything else
/// (`String`/`num`/`bool`/`null`, nested maps and lists) passes through. The
/// app's schema has no field literally named `__ftype`, so the sentinel never
/// collides with real data.
const _typeKey = '__ftype';

/// Encode one value read from Firestore into a JSON-safe representation.
Object? encodeFirestoreValue(Object? value) {
  if (value == null) return null;
  if (value is Timestamp) {
    return {
      _typeKey: 'timestamp',
      'value': value.toDate().toUtc().toIso8601String(),
    };
  }
  if (value is GeoPoint) {
    return {
      _typeKey: 'geopoint',
      'latitude': value.latitude,
      'longitude': value.longitude,
    };
  }
  if (value is DocumentReference) {
    return {_typeKey: 'docref', 'path': value.path};
  }
  if (value is Blob) {
    // Binary blobs (info-board file chunks) are intentionally not exported.
    return null;
  }
  if (value is Map) {
    return {
      for (final e in value.entries)
        e.key.toString(): encodeFirestoreValue(e.value),
    };
  }
  if (value is Iterable) {
    return [for (final e in value) encodeFirestoreValue(e)];
  }
  // String, int, double, bool.
  return value;
}

/// Encode a whole document's field map.
Map<String, dynamic> encodeFirestoreData(Map<String, dynamic> data) => {
      for (final e in data.entries) e.key: encodeFirestoreValue(e.value),
    };

/// Reverse of [encodeFirestoreValue]. [db] is needed only to rebuild
/// [DocumentReference]s (unused by this app's schema, handled defensively).
Object? decodeFirestoreValue(Object? value, {FirebaseFirestore? db}) {
  if (value is Map) {
    final type = value[_typeKey];
    if (type is String) {
      switch (type) {
        case 'timestamp':
          final iso = value['value'];
          return iso is String ? Timestamp.fromDate(DateTime.parse(iso)) : null;
        case 'geopoint':
          return GeoPoint(
            (value['latitude'] as num).toDouble(),
            (value['longitude'] as num).toDouble(),
          );
        case 'docref':
          final path = value['path'];
          return (db != null && path is String) ? db.doc(path) : null;
      }
    }
    return {
      for (final e in value.entries)
        e.key.toString(): decodeFirestoreValue(e.value, db: db),
    };
  }
  if (value is Iterable) {
    return [for (final e in value) decodeFirestoreValue(e, db: db)];
  }
  return value;
}

/// Decode a whole document's field map back to Firestore-writable values.
Map<String, dynamic> decodeFirestoreData(Map<String, dynamic> data,
        {FirebaseFirestore? db}) =>
    {
      for (final e in data.entries) e.key: decodeFirestoreValue(e.value, db: db),
    };
