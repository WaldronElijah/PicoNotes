import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final QuillController _quillController = QuillController.basic();
  bool _isSaving = false;
  final DateTime _createdAt = DateTime.now();
  final NoteRepository _noteRepository = NoteRepository();
  
  // Text formatting state
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  bool _isStrikethrough = false;
  String _currentHeading = 'body'; // 'title', 'heading', 'subheading', 'body'

  // Helper to unset attributes in flutter_quill 11.4.2
  Attribute _unset(Attribute a) {
    // In 11.x Attribute has a public constructor (key, scope, value)
    // Setting value=null unsets it
    return Attribute(a.key, a.scope, null);
  }

  // Returns (start, end, text) for the current line based on the plain text
  ({int start, int end, String text}) _currentLinePlain() {
    final sel = _quillController.selection;
    final full = _quillController.document.toPlainText();
    final i = sel.baseOffset.clamp(0, full.length);
    final start = i > 0 ? (full.lastIndexOf('\n', i - 1) + 1) : 0;
    final nextNewline = full.indexOf('\n', i);
    final end = nextNewline == -1 ? full.length : nextNewline;
    final text = full.substring(start, end);
    return (start: start, end: end, text: text);
  }

  bool _isChecklistAtSelection() {
    final attrs = _quillController.getSelectionStyle().attributes;
    final list = attrs[Attribute.list.key]?.value;
    return list == 'unchecked' || list == 'checked';
  }

  // Handle Backspace on an empty checklist line at line start.
  // Return KeyEventResult.handled when we consume the key.
  KeyEventResult _onEditorKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey != LogicalKeyboardKey.backspace) {
      return KeyEventResult.ignored;
    }

    final sel = _quillController.selection;
    if (!sel.isValid || !sel.isCollapsed) return KeyEventResult.ignored;

    if (!_isChecklistAtSelection()) return KeyEventResult.ignored;

    final line = _currentLinePlain();
    final caretAtLineStart = sel.baseOffset == line.start;
    final lineIsEmpty = line.text.trim().isEmpty;

    if (caretAtLineStart && lineIsEmpty) {
      // Remove the checklist attribute — turns it into a normal empty paragraph.
      _quillController.formatSelection(_unset(Attribute.list));
      // Optionally: keep caret where it is.
      _quillController.updateSelection(
        TextSelection.collapsed(offset: sel.baseOffset),
        ChangeSource.local,
      );
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void initState() {
    super.initState();
    
    // Listen to Quill changes to update button states
    _quillController.addListener(_onQuillChanged);
    
    _focusNode.addListener(() {
      setState(() {
        // Focus state handled by toolbar visibility
      });
    });
    
    // Set initial format to Title (H1) for first words
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
      _quillController.formatSelection(Attribute(Attribute.header.key, Attribute.header.scope, 1));
      setState(() => _currentHeading = 'title');
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
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
      // Note: Alignment state removed as it's not used in UI
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
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // If the document is empty, ensure there's a line to host the checklist.
    if (_quillController.document.length <= 1) {
      _quillController.document.insert(0, '\n');
      _quillController.updateSelection(
        const TextSelection.collapsed(offset: 0),
        ChangeSource.local,
      );
    }

    // Apply Quill's checklist attribute to the current selection/line.
    // Values are 'unchecked' / 'checked'. We'll start with 'unchecked'.
    _quillController.formatSelection(
      Attribute(Attribute.list.key, Attribute.list.scope, 'unchecked'),
    );

    // Optional: move caret to the end of the current line to start typing immediately.
    final newSel = _quillController.selection;
    _quillController.updateSelection(
      TextSelection.collapsed(offset: newSel.extentOffset),
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
    setState(() {
      // Alignment applied to Quill controller
    });
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
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ul);
    }
  }

  void _toggleNumberedList() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ol) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ol);
    }
  }

  void _toggleDashList() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    final attrs = _quillController.getSelectionStyle().attributes;
    final current = attrs[Attribute.list.key];

    if (current == Attribute.ul) {
      _quillController.formatSelection(_unset(Attribute.list));
    } else {
      _quillController.formatSelection(Attribute.ul);
    }
  }

  // Indent methods
  void _setIndentLeft() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent left functionality
  }

  void _setIndentRight() {
    final sel = _quillController.selection;
    if (!sel.isValid) return;

    // TODO: Implement indent right functionality
  }

  Future<void> _saveNote() async {
    // Get plain text content from Quill
    final quillContent = _quillController.document.toPlainText().trim();
    
    if (quillContent.isEmpty) {
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

      // Extract title from first line of content
      final lines = quillContent.split('\n');
      final title = lines.isNotEmpty ? lines.first.trim() : 'Untitled Note';

      final note = Note.create(
        title: title.isEmpty ? 'Untitled Note' : title,
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
            // Header section
            NoteEditorHeader(
              onSave: _saveNote,
              isSaving: _isSaving,
            ),
            
            // Date only under header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                _formatDateTime(_createdAt),
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodySmall,
              ),
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
                                // Apple Notes-style circular checkboxes
                                checkboxTheme: CheckboxThemeData(
                                  shape: const CircleBorder(), // <-- round circles
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  side: WidgetStateBorderSide.resolveWith((states) {
                                    final cs = Theme.of(context).colorScheme;
                                    return BorderSide(
                                      color: states.contains(WidgetState.selected) ? cs.primary : cs.outline,
                                      width: 2,
                                    );
                                  }),
                                  fillColor: WidgetStateProperty.resolveWith((states) {
                                    return states.contains(WidgetState.selected)
                                        ? Theme.of(context).colorScheme.primary
                                        : Colors.transparent;
                                  }),
                                  checkColor: WidgetStateProperty.all(
                                    Theme.of(context).scaffoldBackgroundColor,
                                  ),
                                ),
                              ),
                              child: Focus(
                                onKeyEvent: _onEditorKey,
                                child: QuillEditor.basic(
                                  controller: _quillController,
                                  focusNode: _focusNode,
                                  config: QuillEditorConfig(
                                  placeholder: '',
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
                                    // Lists - SF Pro Text with Apple Notes-style spacing
                                    lists: DefaultListBlockStyle(
                                      TextStyle(
                                        fontSize: 17,
                                        fontFamily: 'SF Pro Text',
                                        fontWeight: FontWeight.w400,
                                        color: textColor,
                                        height: 1.2,
                                      ),
                                      // HorizontalSpacing(indent, gapBetweenCheckboxAndText)
                                      const HorizontalSpacing(18, 12), // <-- more gap between circle & text
                                      const VerticalSpacing(8, 8),      // <-- spacing between items
                                      const VerticalSpacing(8, 8),      // <-- spacing above/below list block
                                      null, // keep these null – DON'T pass a function here
                                      null,
                                    ),
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
              onChecklistTap: () => CustomModals.showChecklistModal(
                context,
                onChecklistInsert: _insertChecklist,
              ),
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