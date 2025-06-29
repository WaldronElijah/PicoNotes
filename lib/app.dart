import 'package:flutter/material.dart';
import 'features/counter/presentation/view/counter_screen.dart';

class PicoNotesApp extends StatelessWidget {
  const PicoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicoNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CounterScreen(),
    );
  }
}
