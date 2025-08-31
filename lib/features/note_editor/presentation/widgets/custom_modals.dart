import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/brand_icon.dart';

// Connected button data class
class _ConnectedButton {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final VoidCallback? onTap;
  final bool isActive;

  const _ConnectedButton(this.label, this.icon, this.isPrimary, {this.onTap, this.isActive = false});
}

class CustomModals {
  // Format Modal - Rich text formatting toolbar
  static void showFormatModal(
    BuildContext context, {
    VoidCallback? onBold,
    VoidCallback? onItalic,
    VoidCallback? onUnderline,
    VoidCallback? onStrikethrough,
    Function(TextAlign)? onTextAlign,
    Function(String)? onHeading,
    bool isBold = false,
    bool isItalic = false,
    bool isUnderline = false,
    bool isStrikethrough = false,
    String currentHeading = 'body',
  }) {
    // 🔧 HOISTED state (persists across setModalState)
    bool localIsBold = isBold;
    bool localIsItalic = isItalic;
    bool localIsUnderline = isUnderline;
    bool localIsStrikethrough = isStrikethrough;
    String localCurrentHeading = currentHeading;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF2C2C2E),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              const SizedBox(height: 20),
              
                             // Format type tabs (Apple style)
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20),
                 child: Row(
                   children: [
                     _buildInteractiveFormatTab('Title', 'title', (type) {
                       onHeading?.call(type);
                       setModalState(() {
                         localCurrentHeading = type;
                       });
                     }, localCurrentHeading == 'title', setModalState),
                     const SizedBox(width: 16),
                     _buildInteractiveFormatTab('Heading', 'heading', (type) {
                       onHeading?.call(type);
                       setModalState(() {
                         localCurrentHeading = type;
                       });
                     }, localCurrentHeading == 'heading', setModalState),
                     const SizedBox(width: 16),
                     _buildInteractiveFormatTab('Subheading', 'subheading', (type) {
                       onHeading?.call(type);
                       setModalState(() {
                         localCurrentHeading = type;
                       });
                     }, localCurrentHeading == 'subheading', setModalState),
                     const SizedBox(width: 16),
                     _buildInteractiveFormatTab('Body', 'body', (type) {
                       onHeading?.call(type);
                       setModalState(() {
                         localCurrentHeading = type;
                       });
                     }, localCurrentHeading == 'body', setModalState),
                   ],
                 ),
               ),
              
              const SizedBox(height: 20),
              
                             // Row 2: Bold, Italic, Underline, Strikethrough (centered and connected)
               Center(
                 child: _buildConnectedButtonGroup([
                   _ConnectedButton('B', CupertinoIcons.bold, true, onTap: () {
                     onBold?.call();
                     setModalState(() {
                       localIsBold = !localIsBold;
                     });
                   }, isActive: localIsBold),
                   _ConnectedButton('I', CupertinoIcons.italic, true, onTap: () {
                     onItalic?.call();
                     setModalState(() {
                       localIsItalic = !localIsItalic;
                     });
                   }, isActive: localIsItalic),
                   _ConnectedButton('U', CupertinoIcons.underline, true, onTap: () {
                     onUnderline?.call();
                     setModalState(() {
                       localIsUnderline = !localIsUnderline;
                     });
                   }, isActive: localIsUnderline),
                   _ConnectedButton('S', CupertinoIcons.strikethrough, true, onTap: () {
                     onStrikethrough?.call();
                     setModalState(() {
                       localIsStrikethrough = !localIsStrikethrough;
                     });
                   }, isActive: localIsStrikethrough),
                 ], isPrimary: true, isWideSpan: true, setModalState: setModalState),
               ),
              
              const SizedBox(height: 20),
              
              // Row 3: Advanced Features with Dropdowns and Special Functions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Bullet List Dropdown (hold for Number, Hyphen)
                    _buildListDropdown(),
                    
                    // Center Alignment Dropdown (hold for Left, Center, Right)
                    _buildAlignmentDropdown(),
                    
                    // Deep Link (Obsidian-style)
                    _buildDeepLinkButton(),
                    
                    // Highlight
                    _buildFormatButton('', CupertinoIcons.paintbrush_fill, false),
                    
                    // Text Color (filled circle)
                    _buildFormatButton('', CupertinoIcons.circle_fill, false),
                    
                    // Divider (line with dash under)
                    _buildFormatButton('', CupertinoIcons.line_horizontal_3, false),
                    
                    // Block Note (filled black box)
                    _buildFormatButton('', CupertinoIcons.square_fill, false),
                    
                    // Calendar Dropdown
                    _buildCalendarButton(),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
        },
      ),
    );
  }

  // Checklist Modal
  static void showChecklistModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Local state for checklist items
          List<Map<String, dynamic>> checklistItems = [
            {'text': 'Sample checklist item', 'completed': false, 'id': DateTime.now().millisecondsSinceEpoch.toString()},
          ];
          
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Checklist',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Checklist items
                Container(
                  constraints: const BoxConstraints(maxHeight: 300),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: checklistItems.length,
                    itemBuilder: (context, index) {
                      final item = checklistItems[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          children: [
                            // Checkbox
                            GestureDetector(
                              onTap: () {
                                setModalState(() {
                                  item['completed'] = !item['completed'];
                                });
                              },
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  color: item['completed'] ? const Color(0xFF3375F8) : Colors.transparent,
                                  border: Border.all(
                                    color: item['completed'] ? const Color(0xFF3375F8) : Colors.grey,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: item['completed']
                                    ? const Icon(
                                        CupertinoIcons.check_mark,
                                        color: Colors.white,
                                        size: 16,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            
                            // Text input
                            Expanded(
                              child: TextField(
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: item['completed'] ? TextDecoration.lineThrough : null,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Checklist item',
                                  hintStyle: TextStyle(color: Color(0xFF8E8E93)),
                                ),
                                onChanged: (value) {
                                  item['text'] = value;
                                },
                              ),
                            ),
                            
                            // Delete button
                            if (checklistItems.length > 1)
                              GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    checklistItems.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: Color(0xFFFF3B30),
                                  size: 20,
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Add new item button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setModalState(() {
                              checklistItems.add({
                                'text': '',
                                'completed': false,
                                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3375F8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(CupertinoIcons.plus, size: 16),
                              SizedBox(width: 8),
                              Text('Add Item'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Insert button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Insert checklist into note
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34C759),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Insert Checklist',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Table Modal
  static void showTableModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          int rows = 3;
          int columns = 3;
          
          return Container(
            decoration: const BoxDecoration(
              color: Color(0xFF2C2C2E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Container(
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Create Table',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
                const SizedBox(height: 20),
                
                // Table dimensions
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Rows',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (rows > 1) {
                                      setModalState(() {
                                        rows--;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.minus_circle_fill,
                                    color: Color(0xFFFF3B30),
                                    size: 24,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$rows',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (rows < 10) {
                                      setModalState(() {
                                        rows++;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.plus_circle_fill,
                                    color: Color(0xFF34C759),
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 20),
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Columns',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    if (columns > 1) {
                                      setModalState(() {
                                        columns--;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.minus_circle_fill,
                                    color: Color(0xFFFF3B30),
                                    size: 24,
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1C1C1E),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '$columns',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (columns < 8) {
                                      setModalState(() {
                                        columns++;
                                      });
                                    }
                                  },
                                  icon: const Icon(
                                    CupertinoIcons.plus_circle_fill,
                                    color: Color(0xFF34C759),
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Table preview
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF3C3C3E)),
                    ),
                    child: Column(
                      children: List.generate(rows, (rowIndex) {
                        return Row(
                          children: List.generate(columns, (colIndex) {
                            return Expanded(
                              child: Container(
                                height: 40,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2C2C2E),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Cell',
                                    style: TextStyle(
                                      color: Color(0xFF8E8E93),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Insert button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Insert table into note
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34C759),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Insert Table',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // Media Modal
  static void showMediaModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            
            // Top row of horizontal sliding circular buttons for media sources
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildMediaSourceButton('Search', CupertinoIcons.search),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Files', CupertinoIcons.folder),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Audio', CupertinoIcons.music_note),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Pinterest', CupertinoIcons.heart),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('YouTube', CupertinoIcons.play_circle),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('TikTok', CupertinoIcons.music_note_2),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Spotify', CupertinoIcons.music_note),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Apple Music', CupertinoIcons.music_note),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('SoundCloud', CupertinoIcons.music_note),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Reddit', CupertinoIcons.globe),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Albums section title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Albums',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'see all',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Albums Grid - Single row with horizontal scrolling and peeking
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 172, // Slightly increased to fit two text lines cleanly
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 10, // Number of album cards
                  itemBuilder: (context, index) {
                    return Padding(
                      // 16 between cards, 20 end padding to create home-like peeking
                      padding: EdgeInsets.only(right: index < 9 ? 16 : 20),
                      child: _buildAlbumCard('Album ${index + 1}', '${(index + 1) * 5} items', index == 0), // First album gets windows image
                    );
                  },
                ),
              ),
            ),
            
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // Media source button (circular with brand colors)
  static Widget _buildMediaSourceButton(String title, IconData icon) {
    // Define brand colors (soft versions)
    Color getBrandColor(String brand) {
      switch (brand.toLowerCase()) {
        case 'files':
          return const Color(0xFF007AFF); // Blue
        case 'audio':
          return const Color(0xFFFFD700); // Light yellow
        case 'pinterest':
          return const Color(0xFFE91E63); // Pink
        case 'tiktok':
          return const Color(0xFF00B4D8); // Blue
        case 'apple music':
          return const Color(0xFFFF6B6B); // Soft red
        case 'spotify':
          return const Color(0xFF1DB954); // Soft green
        case 'youtube':
          return const Color(0xFFFF0000); // Soft red
        case 'reddit':
          return const Color(0xFFFF4500); // Soft red-orange
        case 'soundcloud':
          return const Color(0xFFFF5500); // Soft orange
        default:
          return const Color(0xFF3C3C3E); // Default grey
      }
    }

    return GestureDetector(
      onTap: () {
        print('Media source tapped: $title');
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: getBrandColor(title),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Album card (140x140 square with text below)
  static Widget _buildAlbumCard(String title, String amount, bool useWindowsImage) {
    return Column(
      children: [
        // Image area (140x140 square)
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: useWindowsImage
              ? Image.asset(
                  'media/windows95image.png',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                )
              : Container(
                  color: Colors.grey.shade800,
                  child: const Center(
                    child: Icon(
                      CupertinoIcons.photo,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
          ),
        ),
        // Text below the image - compact two lines
        const SizedBox(height: 4),
        SizedBox(
          width: 140,
          child: Column(
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'SF Pro',
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                amount,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 8,
                  fontFamily: 'SF Pro',
                  height: 1.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Carousel Modal
  static void showCarouselModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Section 1: Clean organized layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left side - 2x2 square (Core Actions)
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.plus,
                                color: Colors.white,
                                size: 20,
                              )), // Add
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.slowmo,
                                color: Colors.white,
                                size: 20,
                              )), // Loading/Progress
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                color: Colors.white,
                                size: 20,
                              )), // Reverse Order
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.arrow_up_left_arrow_down_right,
                                color: Colors.white,
                                size: 20,
                              )), // Resize
                            ],
                          ),
                        ],
                      ),
                      
                      // Middle spacing
                      const SizedBox(width: 40),
                      
                      // Right side - 2 rows of icons (Organization & Captions)
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.list_number,
                                color: Colors.white,
                                size: 20,
                              )), // Number List
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.checkmark_circle,
                                color: Colors.white,
                                size: 20,
                              )), // Check List
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.rectangle_on_rectangle,
                                color: Colors.white,
                                size: 20,
                              )), // Rectangle Swap
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.text_justify,
                                color: Colors.white,
                                size: 20,
                              )), // Text Below Photo
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                color: Colors.white,
                                size: 20,
                              )), // Caption Within Photo
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const Icon(
                                CupertinoIcons.waveform,
                                color: Colors.white,
                                size: 20,
                              )), // Wave Form
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24), // Space between sections
                  
                  
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Stack Modal
  static void showStackModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // Section 1: Clean organized layout
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Left side - 2x2 square (Core Actions)
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildStackIcon(const Icon(
                                CupertinoIcons.plus,
                                color: Colors.white,
                                size: 20,
                              )), // Add
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.slowmo,
                                color: Colors.white,
                                size: 20,
                              )), // Loading/Progress
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStackIcon(const Icon(
                                CupertinoIcons.arrow_up_arrow_down,
                                color: Colors.white,
                                size: 20,
                              )), // Reverse Order
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.arrow_up_left_arrow_down_right,
                                color: Colors.white,
                                size: 20,
                              )), // Resize
                            ],
                          ),
                        ],
                      ),
                      
                      // Middle spacing
                      const SizedBox(width: 40),
                      
                      // Right side - 2 rows of icons (Organization & Captions)
                      Column(
                        children: [
                          Row(
                            children: [
                              _buildStackIcon(const Icon(
                                CupertinoIcons.list_number,
                                color: Colors.white,
                                size: 20,
                              )), // Number List
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.checkmark_circle,
                                color: Colors.white,
                                size: 20,
                              )), // Check List
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.rectangle_on_rectangle,
                                color: Colors.white,
                                size: 20,
                              )), // Rectangle Swap
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStackIcon(const Icon(
                                CupertinoIcons.text_justify,
                                color: Colors.white,
                                size: 20,
                              )), // Text Below Photo
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.photo_fill_on_rectangle_fill,
                                color: Colors.white,
                                size: 20,
                              )), // Caption Within Photo
                              const SizedBox(width: 12),
                              _buildStackIcon(const Icon(
                                CupertinoIcons.waveform,
                                color: Colors.white,
                                size: 20,
                              )), // Wave Form
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  

                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widgets
  static Widget _buildInteractiveFormatTab(String text, String type, Function(String)? onHeading, bool isActive, StateSetter setModalState) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onHeading?.call(type);
          // Don't close modal, just update the state
          setModalState(() {});
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildFormatTab(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  static Widget _buildFormatButton(String label, IconData icon, bool isPrimary) {
    return GestureDetector(
      onTap: () {
        print('Format button tapped: $label');
        // TODO: Implement actual formatting logic
      },
      child: Container(
        width: isPrimary ? 40 : 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
        ),
        child: Center(
          child: label.isNotEmpty 
            ? Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              )
            : Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
        ),
      ),
    );
  }

  // Apple-style primary formatting buttons (Bold, Italic, Underline, Strikethrough)
  static Widget _buildApplePrimaryButton(String label, IconData icon) {
    return GestureDetector(
      onTap: () {
        print('Apple primary format: $label');
      },
      child: Container(
        width: 72,
        height: 48,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ),
      ),
    );
  }

  // Apple-style secondary formatting buttons (smaller tools)
  static Widget _buildAppleSecondaryButton(IconData icon) {
    return GestureDetector(
      onTap: () {
        print('Apple secondary format: $icon');
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  // Long press list button - hold to reveal list options (platform-aware)
  static Widget _buildLongPressListButton() {
    return Builder(
      builder: (context) {
        bool isPressed = false;
        
        return StatefulBuilder(
          builder: (context, setState) => GestureDetector(
            onTap: () {
              // Light haptic feedback on tap
              HapticFeedback.lightImpact();
              print('List button tapped - applying bullet list');
            },
            onLongPress: () {
              // Medium haptic feedback on long press (iOS style)
              HapticFeedback.mediumImpact();
              print('List button long pressed - showing options menu');
              _showListOptionsMenu(context);
            },
            onTapDown: (_) {
              setState(() => isPressed = true);
            },
            onTapUp: (_) {
              setState(() => isPressed = false);
            },
            onTapCancel: () {
              setState(() => isPressed = false);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 40,
              height: 36,
              decoration: BoxDecoration(
                color: isPressed 
                    ? const Color(0xFF4C4C4E) // Lighter when pressed
                    : const Color(0xFF3C3C3E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                CupertinoIcons.list_bullet,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        );
      },
    );
  }

  // Show list options context menu
  static void _showListOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            
            // List options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildListOptionButton('Bullet List', CupertinoIcons.list_bullet, context),
                  _buildListOptionButton('Number List', CupertinoIcons.list_number, context),
                  _buildListOptionButton('Dash List', CupertinoIcons.list_dash, context),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Individual list option button
  static Widget _buildListOptionButton(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        print('Selected: $title');
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SF Pro Text',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Connected button group (Apple segmented control style)
  static Widget _buildConnectedButtonGroup(List<_ConnectedButton> buttons, {bool isPrimary = false, bool isWideSpan = false, StateSetter? setModalState}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF3C3C3E), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: buttons.asMap().entries.map((entry) {
          final index = entry.key;
          final button = entry.value;
          final isFirst = index == 0;
          final isLast = index == buttons.length - 1;
          
          return _buildConnectedButtonItem(
            button,
            isFirst: isFirst,
            isLast: isLast,
            isPrimary: isPrimary,
            isWideSpan: isWideSpan,
            setModalState: setModalState,
          );
        }).toList(),
      ),
    );
  }

  static Widget _buildConnectedButtonItem(
    _ConnectedButton button, {
    required bool isFirst,
    required bool isLast,
    required bool isPrimary,
    bool isWideSpan = false,
    StateSetter? setModalState,
  }) {
    // Calculate button width based on type and span
    double buttonWidth;
    if (isPrimary && isWideSpan) {
      buttonWidth = 72; // iPhone style wider buttons
    } else if (isPrimary) {
      buttonWidth = 64; // Regular primary buttons
    } else {
      buttonWidth = 40; // Secondary buttons
    }
    
    return StatefulBuilder(
      builder: (context, setState) {
        bool isPressed = false;
        
        return GestureDetector(
          onTapDown: (_) {
            setState(() => isPressed = true);
            HapticFeedback.lightImpact();
          },
          onTapUp: (_) {
            setState(() => isPressed = false);
            button.onTap?.call();
            // Trigger modal rebuild to show updated state
            setModalState?.call(() {});
          },
          onTapCancel: () {
            setState(() => isPressed = false);
          },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: buttonWidth,
        height: isPrimary ? 44 : 36,
        decoration: BoxDecoration(
          color: isPressed 
            ? const Color(0xFF2C2C2E) 
            : button.isActive 
              ? const Color(0xFF007AFF) 
              : const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isFirst ? 7 : 0),
            bottomLeft: Radius.circular(isFirst ? 7 : 0),
            topRight: Radius.circular(isLast ? 7 : 0),
            bottomRight: Radius.circular(isLast ? 7 : 0),
          ),
          border: Border(
            right: isLast ? BorderSide.none : const BorderSide(
              color: Color(0xFF2C2C2E),
              width: 1,
            ),
          ),
        ),
        child: Center(
          child: button.isPrimary && button.label.isNotEmpty
              ? Text(
                  button.label,
                  style: TextStyle(
                    color: button.isActive ? Colors.white : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                )
              : Icon(
                  button.icon,
                  color: button.isActive ? Colors.white : Colors.white,
                  size: isPrimary ? 20 : 16,
                ),
        ),
      ),
    );
      },
    );
  }

  static Widget _buildQuickActionCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildFormatActionCard(String title, IconData icon) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildChecklistOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTableOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildMediaIcon(IconData icon, Color color) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  static Widget _buildBrandMediaIcon(String brand) {
    return GestureDetector(
      onTap: () {
        // Handle brand selection - you can add specific logic here
        print('Selected $brand');
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: BrandIcon(
            brand: brand,
            size: 18,
            useOfficialColors: true,
          ),
        ),
      ),
    );
  }

  static Widget _buildFileThumbnail(Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }

  static Widget _buildFileIcon(IconData icon, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static Widget _buildCarouselIcon(Widget icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: icon),
    );
  }

  static Widget _buildStackIcon(Widget icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(child: icon),
    );
  }

  // List dropdown (Bullet, Number, Hyphen) - Long press for options
  static Widget _buildListDropdown() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Default: Bullet list
          print('Applying bullet list');
        },
        onLongPress: () {
          _showListMenu(context);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
          ),
          child: const Icon(
            CupertinoIcons.list_bullet,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // Alignment dropdown (Left, Center, Right) - Long press for options
  static Widget _buildAlignmentDropdown() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Default: Center alignment
          print('Applying center alignment');
        },
        onLongPress: () {
          _showAlignmentMenu(context);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
          ),
          child: const Icon(
            CupertinoIcons.text_aligncenter,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // Deep link button (Obsidian-style)
  static Widget _buildDeepLinkButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          _showDeepLinkDialog(context);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
          ),
          child: const Icon(
            CupertinoIcons.link,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // Calendar button with dropdown
  static Widget _buildCalendarButton() {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          _showCalendarPicker(context);
        },
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3C3C3E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF4C4C4E), width: 1),
          ),
          child: const Icon(
            CupertinoIcons.calendar,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // Show list menu (Number, Hyphen)
  static void _showListMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildListOption('Number', CupertinoIcons.list_number, context),
                  _buildListOption('Hyphen', CupertinoIcons.list_dash, context),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Show alignment menu (Left, Center, Right)
  static void _showAlignmentMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAlignmentOption('Left', CupertinoIcons.text_alignleft, context),
                  _buildAlignmentOption('Center', CupertinoIcons.text_aligncenter, context),
                  _buildAlignmentOption('Right', CupertinoIcons.text_alignright, context),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Show deep link dialog (Obsidian-style)
  static void _showDeepLinkDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Create Deep Link',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Enter note title...',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final title = controller.text.trim();
                      if (title.isNotEmpty) {
                        // TODO: Implement deep link creation
                        print('Creating deep link: [[$title]]');
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Create'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Show calendar picker
  static void _showCalendarPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2C2C2E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2.5),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildDateOption('Today', context),
                  _buildDateOption('Custom', context),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Helper widgets for options
  static Widget _buildListOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        print('Selected list: $title');
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAlignmentOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        print('Selected alignment: $title');
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDateOption(String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        if (title == 'Today') {
          final now = DateTime.now();
          print('Inserting today\'s date: ${now.toString()}');
        } else {
          // TODO: Show date picker
          print('Show custom date picker');
        }
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title == 'Today' ? CupertinoIcons.calendar : CupertinoIcons.calendar_badge_plus,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: 'SF Pro',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 