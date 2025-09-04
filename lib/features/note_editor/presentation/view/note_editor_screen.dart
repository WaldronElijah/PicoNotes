import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../widgets/note_editor_toolbar.dart';
import '../widgets/note_editor_header.dart';
import '../widgets/custom_modals.dart';
import '../../data/repository/note_repository.dart';
import '../../data/models/note.dart';
import '../../../../core/theme/theme_provider.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _titleController = TextEditingController();
  late QuillController _quillController = QuillController.basic();
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

  // Helper to unset attributes in flutter_quill 11.4.2
  Attribute _unset(Attribute a) {
    // In 11.x Attribute has a public constructor (key, scope, value)
    // Setting value=null unsets it
    return Attribute(a.key, a.scope, null);
  }

  @override
  void initState() {
    super.initState();
    
    // Listen to Quill changes to update button states
    _quillController.addListener(_onQuillChanged);
    
    _focusNode.addListener(() {
      setState(() {
        _showToolbar = _focusNode.hasFocus;
      });
    });
    
    // Force body on first line
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
      _quillController.formatSelection(_unset(Attribute.header));
      setState(() => _currentHeading = 'body');
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
    final style = _quillController.getSelectionStyle(); // Style
    final attrs = style.attributes;
    
    setState(() {
      _isBold         = attrs.containsKey(Attribute.bold.key);
      _isItalic       = attrs.containsKey(Attribute.italic.key);
      _isUnderline    = attrs.containsKey(Attribute.underline.key);
      _isStrikethrough= attrs.containsKey(Attribute.strikeThrough.key);

      // Heading state (map 1→title, 2→heading, 3→subheading)
      if (attrs.containsKey(Attribute.header.key)) {
        final h = attrs[Attribute.header.key]!.value;
        _currentHeading = switch (h) {
          1 => 'title',
          2 => 'heading',
          3 => 'subheading',
          _ => 'body',
        };
        debugPrint('header attr: $h');
      } else {
        _currentHeading = 'body';
        debugPrint('header attr: null');
      }
      debugPrint('currentHeading: $_currentHeading');

      // Alignment state (optional UI sync)
      if (attrs.containsKey(Attribute.align.key)) {
        final a = attrs[Attribute.align.key]!.value;
        _textAlign = switch (a) {
          'center'  => TextAlign.center,
          'right'   => TextAlign.right,
          'justify' => TextAlign.justify,
          _         => TextAlign.left,
        };
      } else {
        _textAlign = TextAlign.left;
      }
    });
  }

  // Proper formatting toggles for flutter_quill 11.4.2
  void _toggleBold() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.bold.key);

    _quillController.formatSelection(isOn ? _unset(Attribute.bold) : Attribute.bold);
  }

  void _toggleItalic() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;
    
    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.italic.key);
    
    _quillController.formatSelection(isOn ? _unset(Attribute.italic) : Attribute.italic);
  }

  void _toggleUnderline() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.underline.key);

    _quillController.formatSelection(isOn ? _unset(Attribute.underline) : Attribute.underline);
  }

  void _toggleStrikethrough() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final isOn = attrs.containsKey(Attribute.strikeThrough.key);

    try {
      _quillController.formatSelection(isOn ? _unset(Attribute.strikeThrough) : Attribute.strikeThrough);
    } catch (e) {
      // If strikeThrough is not supported, just toggle the button state
      setState(() {
        _isStrikethrough = !_isStrikethrough;
      });
    }
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
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attr = switch (alignment) {
      TextAlign.center  => Attribute.centerAlignment,
      TextAlign.right   => Attribute.rightAlignment,
      TextAlign.justify => Attribute.justifyAlignment,
      _                 => Attribute.leftAlignment,
    };
    _quillController.formatSelection(attr);
    setState(() => _textAlign = alignment);
  }

  void _setHeading(String headingType) {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    switch (headingType) {
      case 'title':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 1),
        );
        break;
      case 'heading':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 2),
        );
        break;
      case 'subheading':
        _quillController.formatSelection(
          Attribute(Attribute.header.key, Attribute.header.scope, 3),
        );
        break;
      case 'body':
      default:
        _quillController.formatSelection(_unset(Attribute.header));
    }

    setState(() => _currentHeading = headingType);
  }

  // List formatting methods
  void _toggleBulletList() {
    print('Bullet list button tapped!');
    final sel = _quillController.selection;
    if (!sel.isValid) {
      print('Selection not valid');
      return;
    }

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    print('Current list type: $current');

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
      print('Removed bullet list');
    } else {
      _quillController.formatSelection(Attribute.ul);
      print('Added bullet list');
    }
  }

  void _toggleNumberedList() {
    print('Numbered list button tapped!');
    final sel = _quillController.selection;
    if (!sel.isValid) {
      print('Selection not valid');
      return;
    }

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    print('Current list type: $current');

    if (current == Attribute.ol) {
      _quillController.formatSelection(_unset(Attribute.list));
      print('Removed numbered list');
    } else {
      _quillController.formatSelection(Attribute.ol);
      print('Added numbered list');
    }
  }

  void _toggleDashList() {
    print('Dash list button tapped!');
    final sel = _quillController.selection;
    if (!sel.isValid) {
      print('Selection not valid');
      return;
    }

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    print('Current list type: $current');

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
      print('Removed dash list');
    } else {
      _quillController.formatSelection(Attribute.ul);
      print('Added dash list');
    }
  }

  // Indent methods
  void _setIndentLeft() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent left functionality
    print('Indent left tapped');
  }

  void _setIndentRight() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent right functionality
    print('Indent right tapped');
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  color: Theme.of(context).scaffoldBackgroundColor,
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
                            style: Theme.of(context).textTheme.headlineLarge,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'New Note',
                              hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                color: Theme.of(context).hintColor,
                                fontFamily: 'SF Pro Text',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _formatDateTime(_createdAt),
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    
                    // Note content area - now using QuillEditor for rich text
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final themeNotifier = ref.read(themeProvider.notifier);
                            final textColor =
                                themeNotifier.isDarkMode ? Colors.white : Colors.black;

                            return Theme(
                              data: Theme.of(context).copyWith(
                                textTheme: Theme.of(context).textTheme.copyWith(
                                  bodyLarge: TextStyle(color: textColor),
                                  bodyMedium: TextStyle(color: textColor),
                                  bodySmall: TextStyle(color: textColor),
                                ),
                                listTileTheme: ListTileThemeData(
                                  textColor: textColor,
                                  iconColor: textColor,
                                ),
                              ),
                              child: QuillEditor.basic(
                                controller: _quillController,
                                focusNode: _focusNode,
                                config: QuillEditorConfig(
                                  placeholder: 'Start typing...',
                                  padding: EdgeInsets.zero,
                                  minHeight: 100,
                                  maxHeight: double.infinity,
                                  customStyles: DefaultStyles(
                                    // Body text - SF Pro Text, ~17pt, Regular
                                    paragraph: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w400,
                                        color: textColor,
                                        height: 1.2,
                                      ),
                                      const HorizontalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      null,
                                    ),
                                    // Title - SF Pro Display, Larger than body, Semibold/Bold
                                    h1: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 28,
                                        fontFamily: 'SF Pro Display',
                                        fontWeight: FontWeight.w600, // Semibold
                                        color: textColor,
                                        height: 1.1,
                                      ),
                                      const HorizontalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      null,
                                    ),
                                    // Heading - SF Pro Display/Text, Slightly larger than body, Bold
                                    h2: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w700, // Bold
                                        color: textColor,
                                        height: 1.2,
                                      ),
                                      const HorizontalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      null,
                                    ),
                                    // Subheading - SF Pro Text, Same size as body, Bold
                                    h3: DefaultTextBlockStyle(
                                      TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w700, // Bold
                                        color: textColor,
                                        height: 1.2,
                                      ),
                                      const HorizontalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      const VerticalSpacing(0, 0),
                                      null,
                                    ),
                                    // Lists - SF Pro Text with compact indentation
                                    lists: DefaultListBlockStyle(
                                      TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w400,
                                        color: textColor,
                                        height: 1.1, // Tighter line height for lists
                                      ),
                                      const HorizontalSpacing(8, 0), // Very small indent (8px instead of default ~20px)
                                      const VerticalSpacing(1, 0), // Minimal vertical spacing between items
                                      const VerticalSpacing(1, 0),
                                      null, // Checkbox builder (not used for regular lists)
                                      null, // Number builder (not used for regular lists)
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
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
                onBulletList: _toggleBulletList,
                onNumberedList: _toggleNumberedList,
                onDashList: _toggleDashList,
                onIndentLeft: _setIndentLeft,
                onIndentRight: _setIndentRight,
                isBold: _isBold,
                isItalic: _isItalic,
                isUnderline: _isUnderline,
                isStrikethrough: _isStrikethrough,
                currentHeading: _currentHeading,
              ),
              onChecklistTap: () => CustomModals.showChecklistModal(context),
              onTableTap: () => CustomModals.showTableModal(context),
              onMediaTap: () => CustomModals.showMediaModal(context),
              onCarouselTap: () => CustomModals.showCarouselModal(context),
              onStackTap: () => CustomModals.showStackModal(context),
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