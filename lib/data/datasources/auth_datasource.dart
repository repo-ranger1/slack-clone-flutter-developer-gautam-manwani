import 'package:slack_clone_gautam_manwani/core/utils/storage/app_storage.dart';
import 'package:slack_clone_gautam_manwani/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Authentication data source using Firebase Auth and Firestore
class AuthDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final AppStorage _storage;

  AuthDataSource({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    AppStorage? storage,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? AppStorage();

  /// Login with email and password
  /// DEMO MODE: Accepts any email/password combination for new users
  /// Validates password for existing users
  Future<UserModel> login(String email, String password) async {
    try {
      // For demo purposes, accept any email/password
      // Generate a consistent user ID based on email
      final userId = email.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
      final userName = email.split('@')[0];

      // Try to get existing user from Firestore
      final userDoc = await _firestore
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // User exists - check if password matches
        final userData = userDoc.data();
        final storedPassword = userData?['password'] as String?;

        if (storedPassword != null && storedPassword != password) {
          throw Exception('This email is already registered with a different password');
        }
      } else {
        // Create new user document in Firestore for demo
        await _firestore.collection('users').doc(userId).set({
          'name': userName,
          'email': email,
          'password': password, // Store password for validation
        });
      }

      final user = UserModel(
        id: userId,
        name: userName,
        email: email,
      );

      // Store user data in local storage for persistence
      _storage.isLoggedIn.v = true;
      _storage.userId.v = userId;
      _storage.userName.v = userName;
      _storage.userEmail.v = email;

      return user;
    } catch (e) {
      // Re-throw the error to show to user
      rethrow;
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    await _storage.clearAll();
  }

  /// Get current user (Demo mode - uses storage)
  Future<UserModel?> getCurrentUser() async {
    // Check storage for demo mode
    final isLoggedIn = _storage.isLoggedIn.v ?? false;
    if (!isLoggedIn) return null;

    final userId = _storage.userId.v;
    final userName = _storage.userName.v;
    final userEmail = _storage.userEmail.v;

    if (userId == null || userName == null || userEmail == null) {
      return null;
    }

    return UserModel(
      id: userId,
      name: userName,
      email: userEmail,
    );
  }

  /// Check if user is logged in
  Future<bool> isLoggedIn() async {
    final isLoggedIn = _storage.isLoggedIn.v ?? false;
    return isLoggedIn;
  }
}
