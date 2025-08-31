import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _userId;
  bool _isLoading = false;

  // Initialize GoogleSignIn with environment variables
  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    
    // Initialize GoogleSignIn with credentials from .env
    _googleSignIn = GoogleSignIn(
      clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID'], // iOS
      serverClientId: dotenv.env['GOOGLE_WEB_CLIENT_ID'], // Web
      scopes: ['email', 'profile', 'openid'],
    );
    
    _userId = Supabase.instance.client.auth.currentUser?.id;
    
    // Listen to auth state changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      setState(() {
        _userId = data.session?.user.id;
      });
    });
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('🔧 Starting Google Sign-In...');
      print('📱 Using iOS Client ID: ${dotenv.env['GOOGLE_IOS_CLIENT_ID']}');
      print('🌐 Using Web Client ID: ${dotenv.env['GOOGLE_WEB_CLIENT_ID']}');
      
      // Use native Google Sign-In for iOS/Android
      if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
        await _signInWithGoogleNative();
        return; // Important: return here to avoid web flow
      }
      
      // Web flow
      await Supabase.instance.client.auth.signInWithOAuth(OAuthProvider.google);
      
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign-in failed: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogleNative() async {
    try {
      print('📱 Using native Google Sign-In...');
      
      final gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        print('❌ User cancelled Google Sign-In');
        return;
      }

      print('✅ Google Sign-In successful, getting tokens...');
      final gAuth = await gUser.authentication;
      
      final idToken = gAuth.idToken;
      final accessToken = gAuth.accessToken;

      if (idToken == null || accessToken == null) {
        throw Exception('Missing Google tokens');
      }

      print('🔑 Got tokens, signing in with Supabase...');
      await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      print('✅ Supabase authentication successful!');
      
    } catch (e) {
      print('❌ Native Google Sign-In error: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PicoNotes - Sign In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to PicoNotes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Sign in to continue',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton.icon(
                onPressed: _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            const SizedBox(height: 40),
            Text(
              _userId != null ? 'User ID: $_userId' : 'Not signed in',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            // Debug info
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Debug Info:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('iOS Client ID: ${dotenv.env['GOOGLE_IOS_CLIENT_ID'] ?? 'NOT SET'}'),
                  Text('Web Client ID: ${dotenv.env['GOOGLE_WEB_CLIENT_ID'] ?? 'NOT SET'}'),
                  Text('Supabase URL: ${dotenv.env['SUPABASE_URL'] ?? 'NOT SET'}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}