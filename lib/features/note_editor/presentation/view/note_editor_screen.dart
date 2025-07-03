import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/note_editor_header.dart';
import '../viewmodel/note_editor_view_model.dart';

class NoteEditorScreen extends ConsumerWidget {
  const NoteEditorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteState = ref.watch(noteEditorProvider);
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header section with title, date, and navigation
            const NoteEditorHeader(),
            
            // Main content area
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    // Note title section
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'New Note',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SF Pro Text',
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'August 6th, 2023 at 6:30 pm',
                            style: TextStyle(
                              color: const Color(0xFF707071),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Text',
                              letterSpacing: -0.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Note content area
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          maxLines: null,
                          expands: true,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'SF Pro Text',
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Start typing...',
                            hintStyle: TextStyle(
                              color: Color(0xFF8E8E93),
                              fontSize: 16,
                              fontFamily: 'SF Pro Text',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Toolbar at the bottom
            const NoteEditorToolbar(),
          ],
        ),
      ),
    );
  }
} 