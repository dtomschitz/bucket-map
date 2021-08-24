part of blocs.profile;

class ProfileRepository {
  final collection = FirebaseFirestore.instance.collection('profiles');

  Stream<Profile> getProfile(String id) {
    return collection.doc(id).snapshots().map((snapshot) {
      return Profile.fromJson(snapshot.data());
    });
  }

  Future<Profile> getProfileByEmail(String email) async {
    final snapshot = await collection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Profile.fromJson(snapshot.docs.first.data());
  }

  Future<void> createProfile(Profile profile) {
    return collection.doc(profile.id).set(profile.toJson());
  }

  Future<void> updateProfile(Profile update) {
    return collection.doc(update.id).update(update.toJson());
  }
}
