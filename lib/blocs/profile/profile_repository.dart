part of blocs.profile;

class ProfileRepository {
  final profileCollection = FirebaseFirestore.instance.collection('profiles');

  Future<Profile> getProfile(String id) async {
    final snapshot = await profileCollection.doc(id).get();
    return Profile.fromSnapshot(snapshot);
  }

  Future<Profile> getProfileByEmail(String email) async {
    final snapshot = await profileCollection
        .where(
          'email',
          isEqualTo: email,
        )
        .get();

    if (snapshot.docs.isEmpty) return null;
    return Profile.fromSnapshot(snapshot.docs.first);
  }

  Future<void> createProfile(Profile profile) {
    return profileCollection.doc(profile.id).set(profile.toDocument());
  }

  Future<void> updateProfile(Profile update) {
    return profileCollection.doc(update.id).update(update.toDocument());
  }
}
