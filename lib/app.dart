import 'package:flutter/material.dart';
import 'features/note_editor/presentation/view/note_editor_screen.dart';
import 'shared/theme/app_theme.dart';

class PicoNotesApp extends StatelessWidget {
  const PicoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicoNotes',
      theme: AppTheme.darkTheme,
      home: const NoteEditorScreen(),
    );
  }
}
