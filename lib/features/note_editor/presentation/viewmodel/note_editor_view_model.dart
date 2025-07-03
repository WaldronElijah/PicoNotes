import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoteEditorState {
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isEditing;
  final bool hasUnsavedChanges;
  
  const NoteEditorState({
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.isEditing = false,
    this.hasUnsavedChanges = false,
  });
  
  NoteEditorState copyWith({
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isEditing,
    bool? hasUnsavedChanges,
  }) {
    return NoteEditorState(
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isEditing: isEditing ?? this.isEditing,
      hasUnsavedChanges: hasUnsavedChanges ?? this.hasUnsavedChanges,
    );
  }
}

class NoteEditorViewModel extends Notifier<NoteEditorState> {
  @override
  NoteEditorState build() {
    final now = DateTime.now();
    return NoteEditorState(
      title: 'New Note',
      content: '',
      createdAt: now,
      updatedAt: now,
      isEditing: false,
      hasUnsavedChanges: false,
    );
  }
  
  void updateTitle(String newTitle) {
    state = state.copyWith(
      title: newTitle,
      updatedAt: DateTime.now(),
      hasUnsavedChanges: true,
    );
  }
  
  void updateContent(String newContent) {
    state = state.copyWith(
      content: newContent,
      updatedAt: DateTime.now(),
      hasUnsavedChanges: true,
    );
  }
  
  void startEditing() {
    state = state.copyWith(isEditing: true);
  }
  
  void stopEditing() {
    state = state.copyWith(isEditing: false);
  }
  
  void saveNote() {
    // TODO: Implement save functionality when backend is ready
    state = state.copyWith(
      hasUnsavedChanges: false,
      updatedAt: DateTime.now(),
    );
  }
  
  void resetNote() {
    final now = DateTime.now();
    state = NoteEditorState(
      title: 'New Note',
      content: '',
      createdAt: now,
      updatedAt: now,
      isEditing: false,
      hasUnsavedChanges: false,
    );
  }
  
  void applyFormatting(String formatType) {
    // TODO: Implement formatting logic
    // This is a placeholder for when rich text editing is implemented
    print('Applying formatting: $formatType');
  }
  
  void insertTable() {
    // TODO: Implement table insertion
    print('Inserting table');
  }
  
  void insertChecklist() {
    // TODO: Implement checklist insertion
    print('Inserting checklist');
  }
  
  void addPhoto() {
    // TODO: Implement photo addition
    print('Adding photo');
  }
  
  void addDrawing() {
    // TODO: Implement drawing addition
    print('Adding drawing');
  }
}

final noteEditorProvider = NotifierProvider<NoteEditorViewModel, NoteEditorState>(
  NoteEditorViewModel.new,
); 