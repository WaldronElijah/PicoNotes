import 'package:flutter/material.dart';

class PicoNotesApp extends StatelessWidget {
  const PicoNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PicoNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: Center(child: Text('PicoNotes')),
      ),
    );
  }
}
