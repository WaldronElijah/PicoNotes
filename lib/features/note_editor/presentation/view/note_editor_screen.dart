import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/note_editor_header.dart';
import '../widgets/custom_modals.dart';
import '../../data/repository/note_repository.dart';
import '../../data/models/note.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  late QuillController _quillController;
  bool _showToolbar = false;
  bool _isSaving = false;
  final DateTime _createdAt = DateTime.now();
  final NoteRepository _noteRepository = NoteRepository();
  
  // Text formatting state
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  TextAlign _textAlign = TextAlign.left;
  String _currentHeading = 'body'; // 'title', 'heading', 'subheading', 'body'

  @override
  void initState() {
    super.initState();
    
    // Initialize QuillController with empty document
    _quillController = QuillController.basic();
    
    // Listen to Quill changes to update button states
    _quillController.addListener(_onQuillChanged);
    
    _focusNode.addListener(() {
      setState(() {
        _showToolbar = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  // Quill change listener to update button states
  void _onQuillChanged() {
    // For now, we'll just listen to changes but not try to detect current formatting
    // The button states will be updated when users click the formatting buttons
  }

  // Text formatting methods - now using REAL Quill formatting
  void _toggleBold() {
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Apply REAL bold formatting
    _quillController.formatSelection(Attribute.bold);
    
    setState(() {
      _isBold = !_isBold;
    });
  }

  void _toggleItalic() {
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Apply REAL italic formatting
    _quillController.formatSelection(Attribute.italic);
    
    setState(() {
      _isItalic = !_isItalic;
    });
  }

  void _toggleUnderline() {
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Apply REAL underline formatting
    _quillController.formatSelection(Attribute.underline);
    
    setState(() {
      _isUnderline = !_isUnderline;
    });
  }

  void _toggleStrikethrough() {
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Apply REAL strikethrough formatting
    _quillController.formatSelection(Attribute.strikeThrough);
    
    setState(() {
      _isStrikethrough = !_isStrikethrough;
    });
  }

  // Media insertion methods
  void _insertChecklist() {
    // Insert a checklist placeholder into the note
    final checklistText = '''
• [ ] Checklist item 1
• [ ] Checklist item 2
• [ ] Checklist item 3
''';
    
    final selection = _quillController.selection;
    _quillController.document.insert(selection.baseOffset, checklistText);
    
    // Move cursor after the inserted checklist
    _quillController.updateSelection(
      selection.copyWith(
        baseOffset: selection.baseOffset + checklistText.length,
        extentOffset: selection.baseOffset + checklistText.length,
      ),
      ChangeSource.local,
    );
  }

  void _insertTable() {
    // Insert a table placeholder into the note
    final tableText = '''
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Cell 1   | Cell 2   | Cell 3   |
| Cell 4   | Cell 5   | Cell 6   |
''';
    
    final selection = _quillController.selection;
    _quillController.document.insert(selection.baseOffset, tableText);
    
    // Move cursor after the inserted table
    _quillController.updateSelection(
      selection.copyWith(
        baseOffset: selection.baseOffset + tableText.length,
        extentOffset: selection.baseOffset + tableText.length,
      ),
      ChangeSource.local,
    );
  }

  void _insertImagePlaceholder() {
    // Insert an image placeholder
    final imagePlaceholder = '''
[IMAGE PLACEHOLDER]
Caption: Click to add image
''';
    
    final selection = _quillController.selection;
    _quillController.document.insert(selection.baseOffset, imagePlaceholder);
    
    // Move cursor after the inserted placeholder
    _quillController.updateSelection(
      selection.copyWith(
        baseOffset: selection.baseOffset + imagePlaceholder.length,
        extentOffset: selection.baseOffset + imagePlaceholder.length,
      ),
      ChangeSource.local,
    );
  }

  void _insertCarouselPlaceholder() {
    // Insert a carousel placeholder
    final carouselPlaceholder = '''
[CAROUSEL PLACEHOLDER]
Multiple images in horizontal scroll
''';
    
    final selection = _quillController.selection;
    _quillController.document.insert(selection.baseOffset, carouselPlaceholder);
    
    // Move cursor after the inserted placeholder
    _quillController.updateSelection(
      selection.copyWith(
        baseOffset: selection.baseOffset + carouselPlaceholder.length,
        extentOffset: selection.baseOffset + carouselPlaceholder.length,
      ),
      ChangeSource.local,
    );
  }

  void _insertStackPlaceholder() {
    // Insert a stack placeholder
    final stackPlaceholder = '''
[STACK PLACEHOLDER]
Multiple images in vertical stack
''';
    
    final selection = _quillController.selection;
    _quillController.document.insert(selection.baseOffset, stackPlaceholder);
    
    // Move cursor after the inserted placeholder
    _quillController.updateSelection(
      selection.copyWith(
        baseOffset: selection.baseOffset + stackPlaceholder.length,
        extentOffset: selection.baseOffset + stackPlaceholder.length,
      ),
      ChangeSource.local,
    );
  }

  void _setTextAlign(TextAlign alignment) {
    // Apply text alignment to the current selection
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Convert TextAlign to Quill attribute
    Attribute? alignAttribute;
    switch (alignment) {
      case TextAlign.left:
        alignAttribute = Attribute.align;
        break;
      case TextAlign.center:
        alignAttribute = Attribute.align;
        break;
      case TextAlign.right:
        alignAttribute = Attribute.align;
        break;
      case TextAlign.justify:
        alignAttribute = Attribute.align;
        break;
      default:
        alignAttribute = Attribute.align;
    }
    
    // Apply alignment (simplified for now)
    _quillController.formatSelection(alignAttribute);
    
    setState(() {
      _textAlign = alignment;
    });
  }

  void _setHeading(String headingType) {
    // Apply heading formatting to the current selection
    final selection = _quillController.selection;
    if (selection.isCollapsed) return;
    
    // Convert heading type to Quill attribute
    Attribute? headingAttribute;
    switch (headingType) {
      case 'title':
        headingAttribute = Attribute.header;
        break;
      case 'heading':
        headingAttribute = Attribute.header;
        break;
      case 'subheading':
        headingAttribute = Attribute.header;
        break;
      case 'body':
      default:
        headingAttribute = Attribute.header;
        break;
    }
    
    // Apply heading
    _quillController.formatSelection(headingAttribute);
    
    setState(() {
      _currentHeading = headingType;
    });
  }



  Future<void> _saveNote() async {
    // Get plain text content from Quill
    final quillContent = _quillController.document.toPlainText().trim();
    
    if (_titleController.text.trim().isEmpty && quillContent.isEmpty) {
      // Don't save empty notes
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      final note = Note.create(
        title: _titleController.text.trim().isEmpty ? 'Untitled Note' : _titleController.text.trim(),
        content: quillContent,
        userId: user.id,
      );

      await _noteRepository.createNote(note);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to home screen
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header section with title, date, and navigation
            NoteEditorHeader(
              onSave: _saveNote,
              isSaving: _isSaving,
            ),
            
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
                    // Note title section - centered
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'SF Pro Text',
                            ),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'New Note',
                              hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDateTime(_createdAt),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFF707071),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'SF Pro Text',
                              letterSpacing: -0.18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Note content area - now using QuillEditor for rich text
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: QuillEditor.basic(
                          controller: _quillController,
                          focusNode: _focusNode,
                          config: QuillEditorConfig(
                            placeholder: 'Start typing...',
                            padding: EdgeInsets.zero,
                            minHeight: 100,
                            maxHeight: double.infinity,
                            customStyles: DefaultStyles(
                              paragraph: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'SF Pro Text',
                                  color: Colors.white,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h1: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 32,
                                  fontFamily: 'SF Pro Display',
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h2: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 24,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                              h3: DefaultTextBlockStyle(
                                const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'SF Pro Text',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                const HorizontalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                const VerticalSpacing(0, 0),
                                null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Toolbar at the bottom - always show for now to fix the issue
            NoteEditorToolbar(
              onFormatTap: () => CustomModals.showFormatModal(
                context,
                onBold: _toggleBold,
                onItalic: _toggleItalic,
                onUnderline: _toggleUnderline,
                onStrikethrough: _toggleStrikethrough,
                onTextAlign: _setTextAlign,
                onHeading: _setHeading,
                isBold: _isBold,
                isItalic: _isItalic,
                isUnderline: _isUnderline,
                isStrikethrough: _isStrikethrough,
                currentHeading: _currentHeading,
              ),
              onChecklistTap: _insertChecklist,
              onTableTap: _insertTable,
              onMediaTap: _insertImagePlaceholder,
              onCarouselTap: _insertCarouselPlaceholder,
              onStackTap: _insertStackPlaceholder,
              onCloseTap: () => FocusScope.of(context).unfocus(),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final ampm = hour >= 12 ? 'pm' : 'am';
    final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    
    return '$month $day${_getDaySuffix(day)}, $year at $hour12:${minute.toString().padLeft(2, '0')} $ampm';
  }

  String _getDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
} 