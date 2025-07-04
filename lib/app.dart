import 'package:flutter/material.dart';
import 'core/navigation/main_navigation.dart';
import 'shared/theme/app_theme.dart';

class PicoNotesApp extends StatelessWidget {
  const PicoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicoNotes',
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
    );
  }
}
