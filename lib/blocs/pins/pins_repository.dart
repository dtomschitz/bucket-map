part of blocs.locations;

class PinsRepository {
  final collection = FirebaseFirestore.instance.collection('pins');

  Future<void> addLocation(Pin pin) {
    return collection.add(pin.toJson());
  }

  Future<void> deletePin(Pin pin) {
    return collection.doc(pin.id).delete();
  }

  Future<void> updatePin(Pin update) {
    return collection.doc(update.id).update(update.toJson());
  }

  Stream<List<Pin>> pins(String userId) {
    return collection
        .where("userId", isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Pin.fromJson(doc.id, doc.data()))
          .toList();
    });
  }
}
