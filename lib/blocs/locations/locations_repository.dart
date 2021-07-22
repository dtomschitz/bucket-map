part of blocs.locations;

class LocationsRepository {
  final collection = FirebaseFirestore.instance.collection('location');

  Future<void> addLocation(Location location) {
    return collection.add(location.toJson());
  }

  Future<void> deleteLocation(Location location) {
    return collection.doc(location.id).delete();
  }

  Future<void> updateLocation(Location update) {
    return collection.doc(update.id).update(update.toJson());
  }

  Stream<List<Location>> locations(String userId) {
    return collection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Location.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
