import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/note.dart';

class NoteRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Create a new note
  Future<Note> createNote(Note note) async {
    try {
      final response = await _supabase
          .from('notes')
          .insert(note.toJson())
          .select()
          .single();
      
      return Note.fromJson(response);
    } catch (e) {
      print('Error creating note: $e');
      rethrow;
    }
  }

  // Get all notes for a user
  Future<List<Note>> getUserNotes(String userId) async {
    try {
      final response = await _supabase
          .from('notes')
          .select()
          .eq('user_id', userId)
          .order('updated_at', ascending: false);
      
      return response.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching user notes: $e');
      rethrow;
    }
  }

  // Get a single note by ID
  Future<Note?> getNoteById(String noteId) async {
    try {
      final response = await _supabase
          .from('notes')
          .select()
          .eq('id', noteId)
          .single();
      
      return Note.fromJson(response);
    } catch (e) {
      print('Error fetching note: $e');
      return null;
    }
  }

  // Update a note
  Future<Note?> updateNote(Note note) async {
    try {
      final updatedNote = note.copyWith(updatedAt: DateTime.now());
      final response = await _supabase
          .from('notes')
          .update(updatedNote.toJson())
          .eq('id', note.id)
          .select()
          .single();
      
      return Note.fromJson(response);
    } catch (e) {
      print('Error updating note: $e');
      return null;
    }
  }

  // Delete a note
  Future<bool> deleteNote(String noteId) async {
    try {
      await _supabase
          .from('notes')
          .delete()
          .eq('id', noteId);
      
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  // Search notes by title or content
  Future<List<Note>> searchNotes(String userId, String query) async {
    try {
      final response = await _supabase
          .from('notes')
          .select()
          .eq('user_id', userId)
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .order('updated_at', ascending: false);
      
      return response.map((json) => Note.fromJson(json)).toList();
    } catch (e) {
      print('Error searching notes: $e');
      rethrow;
    }
  }
}
