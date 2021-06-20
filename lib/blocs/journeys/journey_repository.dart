part of blocs.journeys;

class JourneysRepository {
  final journeyCollection = FirebaseFirestore.instance.collection('journeys');

  Future<void> addNewJourney(Journey journey) {
    return journeyCollection.add(journey.toJson());
  }

  Stream<List<Journey>> journeys(String userId) {
    return journeyCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Journey.fromJson(doc.data())).toList();
    });
  }
}
