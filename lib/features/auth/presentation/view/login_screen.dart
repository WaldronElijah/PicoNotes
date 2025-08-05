import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/auth/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Test 1: Basic icon
              const Icon(
                Icons.note,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              
              // Test 2: Basic text without any custom fonts
              const Text(
                'PicoNotes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              
              // Test 3: Another text
              const Text(
                'Login Screen Working!',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              
              // Test 4: Basic button
              ElevatedButton(
                onPressed: () {
                  print('Test button pressed');
                },
                child: const Text('Test Button'),
              ),
              
              const SizedBox(height: 20),
              
              // Test 5: Provider test button
              ElevatedButton(
                onPressed: () {
                  // This will test if the provider works
                  try {
                    // Just try to access the provider
                    ref.read(authStateProvider);
                    print('Provider accessed successfully');
                  } catch (e) {
                    print('Provider error: $e');
                  }
                },
                child: const Text('Test Provider'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}