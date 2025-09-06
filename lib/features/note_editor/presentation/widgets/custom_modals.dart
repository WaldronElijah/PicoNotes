import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import '../../../../shared/widgets/brand_icon.dart';
import '../../../../core/widgets/svg_icon.dart';

// Connected button data class
class _ConnectedButton {
  final String label;
  final Widget icon;
  final bool isPrimary;
  final VoidCallback? onTap;
  final bool isActive;

  const _ConnectedButton(this.label, this.icon, this.isPrimary, {this.onTap, this.isActive = false});
}

class CustomModals {
  // Format Modal - Redesigned with grouped islands (Apple design language)
  static void showFormatModal(
    BuildContext context, {
    VoidCallback? onBold,
    VoidCallback? onItalic,
    VoidCallback? onUnderline,
    VoidCallback? onStrikethrough,
    Function(TextAlign)? onTextAlign,
    Function(String)? onHeading,
    VoidCallback? onBulletList,
    VoidCallback? onNumberedList,
    VoidCallback? onDashList,
    VoidCallback? onIndentLeft,
    VoidCallback? onIndentRight,
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
                
                // Title with close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Format',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Text Style Presets (Apple style)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _buildTextStyleTab('Title', 'title', (type) {
                        onHeading?.call(type);
                        setModalState(() {
                          localCurrentHeading = type;
                        });
                      }, localCurrentHeading == 'title'),
                      const SizedBox(width: 16),
                      _buildTextStyleTab('Heading', 'heading', (type) {
                        onHeading?.call(type);
                        setModalState(() {
                          localCurrentHeading = type;
                        });
                      }, localCurrentHeading == 'heading'),
                      const SizedBox(width: 16),
                      _buildTextStyleTab('Subheading', 'subheading', (type) {
                        onHeading?.call(type);
                        setModalState(() {
                          localCurrentHeading = type;
                        });
                      }, localCurrentHeading == 'subheading'),
                      const SizedBox(width: 16),
                      _buildTextStyleTab('Body', 'body', (type) {
                        onHeading?.call(type);
                        setModalState(() {
                          localCurrentHeading = type;
                        });
                      }, localCurrentHeading == 'body'),
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Row 1: Bold/Italic/Underline/Strikethrough + Color Picker + Brush + Calendar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Text formatting island (smaller)
                      _buildTextFormattingIsland(
                        localIsBold, localIsItalic, localIsUnderline, localIsStrikethrough,
                        () {
                          onBold?.call();
                          setModalState(() {
                            localIsBold = !localIsBold;
                          });
                        },
                        () {
                          onItalic?.call();
                          setModalState(() {
                            localIsItalic = !localIsItalic;
                          });
                        },
                        () {
                          onUnderline?.call();
                          setModalState(() {
                            localIsUnderline = !localIsUnderline;
                          });
                        },
                        () {
                          onStrikethrough?.call();
                          setModalState(() {
                            localIsStrikethrough = !localIsStrikethrough;
                          });
                        },
                        setModalState
                      ),
                      
                      const SizedBox(width: 12),
                      
                      // Color picker and brush island
                      _buildColorBrushIsland(),
                      
                      const SizedBox(width: 12),
                      
                      // Calendar solo island
                      _buildCalendarIsland(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Row 2: Bullet/Number + Space + Indent (Left/Right) + Space + Deeplink + Space + Block/Divider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      // Bullet and Number list island
                      _buildListIsland(onBulletList, onNumberedList),
                      
                      const SizedBox(width: 8),
                      
                      // Indent island (Left/Right)
                      _buildIndentIsland(onIndentLeft, onIndentRight),
                      
                      const SizedBox(width: 8),
                      
                      // Deep link island
                      _buildDeepLinkIsland(),
                      
                      const SizedBox(width: 8),
                      
                      // Block note and divider combined island
                      _buildBlockDividerIsland(),
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
  static void showChecklistModal(BuildContext context, {VoidCallback? onChecklistInsert}) {
    // Insert checklist immediately when modal opens
    if (onChecklistInsert != null) {
      onChecklistInsert();
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Track which option is selected
          String selectedOption = 'checklist';
          
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
                
                // Title with close button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Checklist',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildChecklistOption(
                          'checklist',
                          const SvgIcon('006-checklist', size: 24, color: Colors.white),
                          context,
                          isSelected: selectedOption == 'checklist',
                          onTap: () {
                            setModalState(() {
                              selectedOption = 'checklist';
                            });
                            // Checklist already inserted when modal opened, just close
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChecklistOption(
                          'consistency\ntracker list',
                          const Icon(CupertinoIcons.square_grid_3x2, color: Colors.white, size: 24),
                          context,
                          isSelected: selectedOption == 'consistency',
                          onTap: () {
                            setModalState(() {
                              selectedOption = 'consistency';
                            });
                            // Future functionality - just close for now
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildChecklistOption(
                          'progress\ntracker list',
                          const Icon(CupertinoIcons.star, color: Colors.white, size: 24),
                          context,
                          isSelected: selectedOption == 'progress',
                          onTap: () {
                            setModalState(() {
                              selectedOption = 'progress';
                            });
                            // Future functionality - just close for now
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
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

  // Table Modal
  static void showTableModal(BuildContext context) {
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
            
            // Title with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Table',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTableOption(
                      'table',
                      const Icon(CupertinoIcons.table, color: Colors.white, size: 24),
                      context,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTableOption(
                      'line table',
                      const Icon(CupertinoIcons.line_horizontal_3, color: Colors.white, size: 24),
                      context,
                    ),
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

  // Media Modal
  static void showMediaModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
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
            
            // Title with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Media',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
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
                    _buildMediaSourceButton('Search', const Icon(CupertinoIcons.search, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Files', const Icon(CupertinoIcons.folder, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Audio', const Icon(CupertinoIcons.music_note, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Pinterest', const SvgIcon('001-pintrest', size: 20, color: Colors.white)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('YouTube', const Icon(CupertinoIcons.play_circle, color: Colors.white, size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('TikTok', const SvgIcon('002-tiktok', size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Spotify', const SvgIcon('005-spotify', size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Apple Music', const SvgIcon('004-applemusic', size: 20)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('SoundCloud', const SvgIcon('003-soundcloud-logo', size: 20, color: Colors.white)),
                    const SizedBox(width: 12),
                    _buildMediaSourceButton('Reddit', const Icon(CupertinoIcons.globe, color: Colors.white, size: 20)),
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
  static Widget _buildMediaSourceButton(String title, Widget icon) {
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
            SizedBox(
              width: 20,
              height: 20,
              child: icon,
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
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Track alignment state
          bool isVerticalAlignment = true;
          
          return Container(
        height: MediaQuery.of(context).size.height * 0.25,
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
            
            // Title with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Carousel',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
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
                              _buildCarouselIcon(
                                GestureDetector(
                                  onTap: () {
                                    setModalState(() {
                                      isVerticalAlignment = !isVerticalAlignment;
                                    });
                                  },
                                  child: SvgIcon(
                                    isVerticalAlignment ? '010-vertical-alignment' : '012-horizontal-alignment',
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ), // Alignment Toggle
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const SvgIcon(
                                '013-resize',
                                size: 20,
                                color: Colors.white,
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
                              _buildCarouselIcon(const SvgIcon(
                                '006-checklist',
                                size: 20,
                                color: Colors.white,
                              )), // Check List
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const SvgIcon(
                                '014-reorder',
                                size: 20,
                                color: Colors.white,
                              )), // Reorder
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildCarouselIcon(const SvgIcon(
                                '009-caption',
                                size: 20,
                                color: Colors.white,
                              )), // Caption
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const SvgIcon(
                                '008-subtitle',
                                size: 20,
                                color: Colors.white,
                              )), // Subtitle
                              const SizedBox(width: 12),
                              _buildCarouselIcon(const SvgIcon(
                                '007-addsong',
                                size: 20,
                                color: Colors.white,
                              )), // Add Song
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
      );
        },
      ),
    );
  }

  // Stack Modal
  static void showStackModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.25,
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
            
            // Title with close button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Text(
                    'Stack',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
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
                              _buildStackIcon(const SvgIcon(
                                '010-vertical-alignment',
                                size: 20,
                                color: Colors.white,
                              )), // Alignment Toggle
                              const SizedBox(width: 12),
                              _buildStackIcon(const SvgIcon(
                                '013-resize',
                                size: 20,
                                color: Colors.white,
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
                              _buildStackIcon(const SvgIcon(
                                '006-checklist',
                                size: 20,
                                color: Colors.white,
                              )), // Check List
                              const SizedBox(width: 12),
                              _buildStackIcon(const SvgIcon(
                                '014-reorder',
                                size: 20,
                                color: Colors.white,
                              )), // Reorder
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStackIcon(const SvgIcon(
                                '009-caption',
                                size: 20,
                                color: Colors.white,
                              )), // Caption
                              const SizedBox(width: 12),
                              _buildStackIcon(const SvgIcon(
                                '008-subtitle',
                                size: 20,
                                color: Colors.white,
                              )), // Subtitle
                              const SizedBox(width: 12),
                              _buildStackIcon(const SvgIcon(
                                '007-addsong',
                                size: 20,
                                color: Colors.white,
                              )), // Add Song
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
              : SizedBox(
                  width: isPrimary ? 20 : 16,
                  height: isPrimary ? 20 : 16,
                  child: button.icon,
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

  static Widget _buildChecklistOption(
    String title, 
    Widget icon, 
    BuildContext context, {
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.grey.shade600 : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: Colors.grey.shade400, width: 1) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: icon,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.grey.shade200 : Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTableOption(String title, Widget icon, BuildContext context) {
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
            SizedBox(
              width: 24,
              height: 24,
              child: icon,
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
  static Widget _buildListDropdown(VoidCallback? onBulletList, VoidCallback? onNumberedList, VoidCallback? onDashList) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Default: Bullet list
          onBulletList?.call();
        },
        onLongPress: () {
          _showListMenu(context, onBulletList, onNumberedList, onDashList);
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
  static Widget _buildAlignmentDropdown(VoidCallback? onLeftAlign, VoidCallback? onCenterAlign, VoidCallback? onRightAlign) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          // Default: Center alignment
          onCenterAlign?.call();
        },
        onLongPress: () {
          _showAlignmentMenu(context, onLeftAlign, onCenterAlign, onRightAlign);
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
  static void _showListMenu(BuildContext context, VoidCallback? onBulletList, VoidCallback? onNumberedList, VoidCallback? onDashList) {
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
                  _buildListOption('Number', CupertinoIcons.list_number, context, onNumberedList),
                  _buildListOption('Hyphen', CupertinoIcons.list_dash, context, onDashList),
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
  static void _showAlignmentMenu(BuildContext context, VoidCallback? onLeftAlign, VoidCallback? onCenterAlign, VoidCallback? onRightAlign) {
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
                  _buildAlignmentOption('Left', CupertinoIcons.text_alignleft, context, onLeftAlign),
                  _buildAlignmentOption('Center', CupertinoIcons.text_aligncenter, context, onCenterAlign),
                  _buildAlignmentOption('Right', CupertinoIcons.text_alignright, context, onRightAlign),
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
  static Widget _buildListOption(String title, IconData icon, BuildContext context, VoidCallback? onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
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

  static Widget _buildAlignmentOption(String title, IconData icon, BuildContext context, VoidCallback? onTap) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        onTap?.call();
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

  // ===== NEW ISLAND BUILDERS =====

  // Text style tab (Apple style)
  static Widget _buildTextStyleTab(String text, String type, Function(String)? onHeading, bool isActive) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onHeading?.call(type);
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
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }

  // Text formatting island (Bold, Italic, Underline, Strikethrough) - smaller
  static Widget _buildTextFormattingIsland(
    bool isBold, bool isItalic, bool isUnderline, bool isStrikethrough,
    VoidCallback? onBold, VoidCallback? onItalic, VoidCallback? onUnderline, VoidCallback? onStrikethrough,
    StateSetter setModalState
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormatButton('B', const Icon(CupertinoIcons.bold, color: Colors.white, size: 20), isBold, () {
            onBold?.call();
            setModalState(() {
              // State will be updated by the parent component
            });
          }),
          _buildFormatButton('I', const Icon(CupertinoIcons.italic, color: Colors.white, size: 20), isItalic, () {
            onItalic?.call();
            setModalState(() {
              // State will be updated by the parent component
            });
          }),
          _buildFormatButton('U', const Icon(CupertinoIcons.underline, color: Colors.white, size: 20), isUnderline, () {
            onUnderline?.call();
            setModalState(() {
              // State will be updated by the parent component
            });
          }),
          _buildFormatButton('S', const Icon(CupertinoIcons.strikethrough, color: Colors.white, size: 20), isStrikethrough, () {
            onStrikethrough?.call();
            setModalState(() {
              // State will be updated by the parent component
            });
          }),
        ],
      ),
    );
  }

  // Color picker and brush island
  static Widget _buildColorBrushIsland() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormatButton('', const Icon(CupertinoIcons.circle_fill, color: Colors.white, size: 20), false, () {
            print('Color picker tapped');
          }),
          _buildFormatButton('', const SvgIcon('015-marker', size: 20, color: Colors.white), false, () {
            print('Marker tapped');
          }),
        ],
      ),
    );
  }

  // Calendar solo island
  static Widget _buildCalendarIsland() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildFormatButton('', const Icon(CupertinoIcons.calendar, color: Colors.white, size: 20), false, () {
        print('Calendar tapped');
      }),
    );
  }

  // List island (Bullet and Number) - no popup
  static Widget _buildListIsland(VoidCallback? onBulletList, VoidCallback? onNumberedList) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormatButton('', const Icon(CupertinoIcons.list_bullet, color: Colors.white, size: 20), false, () {
            onBulletList?.call();
          }),
          _buildFormatButton('', const Icon(CupertinoIcons.list_number, color: Colors.white, size: 20), false, () {
            onNumberedList?.call();
          }),
        ],
      ),
    );
  }

  // Indent island (Indent Left, Indent Right)
  static Widget _buildIndentIsland(VoidCallback? onIndentLeft, VoidCallback? onIndentRight) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormatButton('', const SvgIcon('018-indent-left-2', size: 20, color: Colors.white), false, () {
            onIndentLeft?.call();
          }),
          _buildFormatButton('', const SvgIcon('016-indent-right', size: 20, color: Colors.white), false, () {
            onIndentRight?.call();
          }),
        ],
      ),
    );
  }

  // Deep link island
  static Widget _buildDeepLinkIsland() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: _buildFormatButton('', const Icon(CupertinoIcons.link, color: Colors.white, size: 20), false, () {
        print('Deep link tapped');
      }),
    );
  }

  // Block note and divider combined island
  static Widget _buildBlockDividerIsland() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFormatButton('', const Icon(CupertinoIcons.square_fill, color: Colors.white, size: 20), false, () {
            print('Block note tapped');
          }),
          _buildFormatButton('', const SvgIcon('022-divider', size: 20, color: Colors.white), false, () {
            print('Divider tapped');
          }),
        ],
      ),
    );
  }

  // Format button helper (Apple style) - Updated version
  static Widget _buildFormatButton(String label, Widget icon, bool isActive, VoidCallback? onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap?.call();
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF007AFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: label.isNotEmpty 
            ? Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro Text',
                ),
              )
            : SizedBox(
                width: 20,
                height: 20,
                child: icon,
              ),
        ),
      ),
    );
  }


  // Simple option helper for checklist and table modals
  static Widget _buildSimpleOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
        print('Selected: $title');
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 