import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  late final GoogleSignIn _googleSignIn;

  AuthService() {
    try {
      final iosClientId = dotenv.env['GOOGLE_IOS_CLIENT_ID'];
      final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID'];
      
      print('🔧 Initializing GoogleSignIn with:');
      print('   iOS Client ID: ${iosClientId ?? "NOT SET"}');
      print('   Web Client ID: ${webClientId ?? "NOT SET"}');
      print('   Platform: ${kIsWeb ? "Web" : "Native"}');
      
      if (iosClientId == null || webClientId == null) {
        throw 'Missing Google client IDs in environment configuration';
      }
      
      _googleSignIn = GoogleSignIn(
        clientId: iosClientId,
        serverClientId: webClientId,
        scopes: ['email', 'profile', 'openid'],
      );
      print('✅ GoogleSignIn initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize GoogleSignIn: $e');
      rethrow;
    }
  }

  SupabaseClient get _supabase {
    return Supabase.instance.client;
  }

  User? get currentUser {
    return _supabase.auth.currentUser;
  }

  Stream<AuthState> get authStateChanges {
    return _supabase.auth.onAuthStateChange;
  }

  // Sign in with Google using native Google Sign-In
  Future<void> signInWithGoogle() async {
    // Ensure we're using native flow on mobile platforms
    if (kIsWeb) {
      throw 'Web platform not supported - use native flow only';
    }
    
    try {
      print('🔐 Starting Google Sign-In process...');
      print('📱 Platform: ${kIsWeb ? "Web" : "Native"}');
      
      print('📱 Calling GoogleSignIn.signIn()...');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        print('❌ Google Sign-In was cancelled by user');
        throw 'Google Sign-In was cancelled';
      }

      print('✅ Google Sign-In successful, getting authentication...');
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      print('🔑 Tokens received - Access: ${accessToken != null ? "YES" : "NO"}, ID: ${idToken != null ? "YES" : "NO"}');

      if (accessToken == null) {
        throw 'No Access Token found';
      }
      if (idToken == null) {
        throw 'No ID Token found';
      }

      print('🚀 Sending tokens to Supabase...');
      await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      
      print('✅ Supabase authentication successful!');
    } catch (e) {
      print('❌ Google Sign-In failed: $e');
      throw 'Google Sign-In failed: $e';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _supabase.auth.signOut();
    } catch (e) {
      throw 'Sign out failed: $e';
    }
  }

  // Check if user is signed in
  bool get isSignedIn => currentUser != null;

  // Get current session
  Session? get currentSession {
    return _supabase.auth.currentSession;
  }
} 