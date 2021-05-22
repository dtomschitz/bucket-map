import 'dart:async';
import 'package:bucket_map/models/models.dart';
import 'package:cache/cache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:meta/meta.dart';
import 'package:bucket_map/models/user.dart';

/// Thrown if during the sign up process if a failure occurs.
class SignUpFailure implements Exception {}

/// Thrown during the login process if a failure occurs.
class LogInWithEmailAndPasswordFailure implements Exception {}

/// Thrown during the sign in with google process if a failure occurs.
class LogInWithGoogleFailure implements Exception {}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// Repository which manages user authentication.
class AuthenticationRepository {
  AuthenticationRepository({
    CacheClient cache,
    firebase_auth.FirebaseAuth firebaseAuth,
  })  : _cache = cache ?? CacheClient(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final CacheClient _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  // collection reference for firebase
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  /// User cache key.
  /// Should only be used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.anonymous] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.anonymous : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.anonymous] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.anonymous;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpFailure] if an exception occurs.
  Future<void> signUp({
    @required String email,
    @required String password,
    String id,
    String name,
    String photo,
    String currentCountry,
  }) async {
    try {
      final userCredentials =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCollection.doc(userCredentials.user.uid).set({
        'id': userCredentials.user.uid,
        'name': name,
        'photo': photo,
        'currentCountry': currentCountry,
        'countries': [],
        'pinIds': [],
      });
    } on Exception {
      throw SignUpFailure();
    }
  }

  Future<void> updatePassword(String password) async {
    final currentUser = _firebaseAuth.currentUser;
    await currentUser.updatePassword(password);
  }

  //user list from snapshot
  List<User> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return User(
        id: doc.data()['id'] ?? '',
        name: doc.data()['name'] ?? 'Test',
        photo: doc.data()['photo'] ?? '',
        //planned: doc.data()['planned'] ?? 0,
        //mountCountries: doc.data()['amountCountries'] ?? 0,
        //amountPins: doc.data()['amountPins'] ?? 0,
        currentCountry: doc.data()['currentCountry'] ?? 'Deutschland',
        countries: doc.data()['countries'] ?? [],
        pinIds: doc.data()['pinIds'] ?? [],
      );
    }).toList();
  }

  //get users stream from firebase
  Stream<List<User>> get users {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    @required String email,
    @required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on Exception {
      throw LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.anonymous] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await _firebaseAuth.signOut();
    } on Exception {
      throw LogOutFailure();
    }
  }
}

extension on firebase_auth.User {
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
