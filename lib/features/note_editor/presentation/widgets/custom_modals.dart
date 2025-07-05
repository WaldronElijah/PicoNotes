import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sf_symbols/sf_symbols.dart';
import '../../../../shared/widgets/brand_icon.dart';

// Connected button data class
class _ConnectedButton {
  final String label;
  final IconData icon;
  final bool isPrimary;

  const _ConnectedButton(this.label, this.icon, this.isPrimary);
}

class CustomModals {
  // Format Modal - Rich text formatting toolbar
  static void showFormatModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
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
            
            // Format type tabs (Apple style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _buildFormatTab('Title', true),
                  const SizedBox(width: 16),
                  _buildFormatTab('Heading', false),
                  const SizedBox(width: 16),
                  _buildFormatTab('Subheading', false),
                  const SizedBox(width: 16),
                  _buildFormatTab('Body', false),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Primary formatting buttons (iPhone style - wider span, centered)
            Center(
              child: _buildConnectedButtonGroup([
                _ConnectedButton('', CupertinoIcons.bold, true),
                _ConnectedButton('', CupertinoIcons.italic, true),
                _ConnectedButton('', CupertinoIcons.underline, true),
                _ConnectedButton('', CupertinoIcons.strikethrough, true),
              ], isPrimary: true, isWideSpan: true),
            ),
            
            const SizedBox(height: 16),
            
            // All secondary tools in one row (Connected groups)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Long press list button (saves space)
                  _buildLongPressListButton(),
                  
                  // Text alignment group
                  _buildConnectedButtonGroup([
                    _ConnectedButton('', CupertinoIcons.text_alignleft, false),
                    _ConnectedButton('', CupertinoIcons.text_aligncenter, false),
                  ]),
                  
                  // Color and formatting group
                  _buildConnectedButtonGroup([
                    _ConnectedButton('', CupertinoIcons.textformat_size, false),
                    _ConnectedButton('', CupertinoIcons.paintbrush, false),
                    _ConnectedButton('', CupertinoIcons.squares_below_rectangle, false),
                  ]),
                  
                  // Advanced tools group
                  _buildConnectedButtonGroup([
                    _ConnectedButton('', CupertinoIcons.stop_fill, false),
                    _ConnectedButton('', CupertinoIcons.flowchart, false),
                  ]),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Checklist Modal
  static void showChecklistModal(BuildContext context) {
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
              child: Row(
                children: [
                  Expanded(
                    child: _buildChecklistOption(
                      'checklist',
                      CupertinoIcons.check_mark_circled,
                      context,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildChecklistOption(
                      'consistency\ntracker list',
                      CupertinoIcons.square_grid_3x2,
                      context,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildChecklistOption(
                      'progress\ntracker list',
                      CupertinoIcons.star,
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
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTableOption(
                      'table',
                      CupertinoIcons.table,
                      context,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTableOption(
                      'line table',
                      CupertinoIcons.line_horizontal_3,
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

  // Photo Bank Modal
  static void showPhotoBankModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
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
                  // Social Media & Content Platforms Row 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBrandMediaIcon('youtube'),
                      _buildBrandMediaIcon('instagram'),
                      _buildBrandMediaIcon('tiktok'),
                      _buildBrandMediaIcon('x'),
                      _buildBrandMediaIcon('reddit'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Music & Content Platforms Row 2
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildBrandMediaIcon('spotify'),
                      _buildBrandMediaIcon('apple music'),
                      _buildBrandMediaIcon('soundcloud'),
                      _buildBrandMediaIcon('maps'),
                      _buildBrandMediaIcon('pinterest'),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Additional options row
                  Row(
                    children: [
                      _buildMediaIcon(CupertinoIcons.camera, Colors.grey),
                      const SizedBox(width: 16),
                      _buildMediaIcon(CupertinoIcons.photo_on_rectangle, Colors.grey),
                      const SizedBox(width: 16),
                      _buildMediaIcon(CupertinoIcons.doc, Colors.grey),
                      const SizedBox(width: 16),
                      _buildMediaIcon(CupertinoIcons.link, Colors.blue),
                      const Spacer(),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Files section
                  Row(
                    children: [
                      const Text(
                        'All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'see all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // File thumbnails
                  Row(
                    children: [
                      _buildFileThumbnail(Colors.blue),
                      const SizedBox(width: 8),
                      _buildFileThumbnail(Colors.green),
                      const SizedBox(width: 8),
                      _buildFileThumbnail(Colors.grey),
                      const SizedBox(width: 8),
                      _buildFileThumbnail(Colors.brown),
                      const SizedBox(width: 8),
                      _buildFileThumbnail(Colors.pink),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      const Text(
                        'Files',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'see all',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // File icons
                  Row(
                    children: [
                      _buildFileIcon(CupertinoIcons.folder, Colors.blue),
                      const SizedBox(width: 16),
                      _buildFileIcon(CupertinoIcons.folder, Colors.green),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
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
                              _buildCarouselIcon(
                                SfSymbol(
                                  name: 'rectangle.2.swap',
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ), // Rectangle Swap
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildCarouselIcon(
                                SfSymbol(
                                  name: 'text.below.photo',
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ), // Text Below Photo
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
                              _buildStackIcon(
                                SfSymbol(
                                  name: 'rectangle.2.swap',
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ), // Rectangle Swap
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              _buildStackIcon(
                                SfSymbol(
                                  name: 'text.below.photo',
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ), // Text Below Photo
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

  static Widget _buildFormatButton(IconData icon, [double size = 32]) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 16,
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
  static Widget _buildConnectedButtonGroup(List<_ConnectedButton> buttons, {bool isPrimary = false, bool isWideSpan = false}) {
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
    
    return GestureDetector(
      onTap: () {
        print('Connected button tapped: ${button.label.isNotEmpty ? button.label : button.icon}');
      },
      child: Container(
        width: buttonWidth,
        height: isPrimary ? 44 : 36,
        decoration: BoxDecoration(
          color: const Color(0xFF3C3C3E),
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                )
              : Icon(
                  button.icon,
                  color: Colors.white,
                  size: isPrimary ? 20 : 16,
                ),
        ),
      ),
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
} 