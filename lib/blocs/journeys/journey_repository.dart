part of blocs.journeys;

class JourneysRepository {
  final journeyCollection = FirebaseFirestore.instance.collection('journeys');

  Future<void> addNewJourney(Journey journey) {
    return journeyCollection.add(journey.toEntity().toDocument());
  }

  @override
  Stream<List<Journey>> journeys() {
    return journeyCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Journey.fromEntity(JourneyEntity.fromSnapshot(doc)))
          .toList();
    });
  }
}
