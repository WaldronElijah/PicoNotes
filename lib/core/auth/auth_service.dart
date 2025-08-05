import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;

  // Sign in with Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Start Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw 'Google Sign-In was cancelled';
      }

      // Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) {
        throw 'No Access Token found';
      }
      if (idToken == null) {
        throw 'No ID Token found';
      }

      // Sign in to Supabase with Google credentials
      final AuthResponse response = await _supabase.auth.signInWithIdToken(
        provider: Provider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      throw 'Google Sign-In failed: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
      await _secureStorage.deleteAll();
    } catch (e) {
      throw 'Sign out failed: $e';
    }
  }

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get current session
  Session? get currentSession => _supabase.auth.currentSession;
} 