import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/note_editor_view_model.dart';

class NoteEditorToolbar extends ConsumerWidget {
  const NoteEditorToolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF323233),
      ),
      child: Row(
        children: [
          // Heading label
          Container(
            padding: const EdgeInsets.only(left: 4, right: 8),
            child: const Text(
              'Heading',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ),
          
          // Vertical separator
          Container(
            width: 1,
            height: 24,
            color: Colors.white.withOpacity(0.3),
          ),
          
          // Toolbar buttons
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Format button
                _buildToolbarButton(
                  context,
                  '􀅑', // SF Symbol: bold
                  onTap: () => _showFormatModal(context),
                ),
                
                // Checklist button
                _buildToolbarButton(
                  context,
                  '􀷾', // SF Symbol: checklist
                  onTap: () => _showChecklistModal(context),
                ),
                
                // Table button
                _buildToolbarButton(
                  context,
                  '􀏣', // SF Symbol: table
                  onTap: () => _showTableModal(context),
                ),
                
                // Plus rectangle button
                _buildToolbarButton(
                  context,
                  '􀏩', // SF Symbol: plus.rectangle.on.rectangle
                  onTap: () => _showLayoutModal(context),
                ),
                
                // Stack badge button
                _buildToolbarButton(
                  context,
                  '􀏱', // SF Symbol: rectangle.stack.badge.plus
                  onTap: () => _showStackModal(context),
                ),
                
                // Brain button
                _buildToolbarButton(
                  context,
                  '􀯏', // SF Symbol: brain.head.profile
                  onTap: () => _showBrainModal(context),
                ),
                
                // Photo button
                _buildToolbarButton(
                  context,
                  '􀏅', // SF Symbol: photo
                  onTap: () => _showPhotoModal(context),
                ),
                
                // Chevron down button
                _buildToolbarButton(
                  context,
                  '􀆈', // SF Symbol: chevron.down
                  onTap: () => _showMoreToolsModal(context),
                ),
              ],
            ),
          ),
          
          // Hide keyboard button
          Container(
            padding: const EdgeInsets.only(right: 8),
            child: _buildToolbarButton(
              context,
              '􀅾', // SF Symbol: keyboard.chevron.compact.down
              color: const Color(0xFF8E8E93),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildToolbarButton(
    BuildContext context,
    String symbol, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Text(
          symbol,
          style: TextStyle(
            color: color ?? Colors.white,
            fontSize: 17,
            fontFamily: 'SF Pro Text',
          ),
        ),
      ),
    );
  }
  
  void _showFormatModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Format Options',
        [
          _buildModalOption('Bold', '􀅑', context),
          _buildModalOption('Italic', '􀅒', context),
          _buildModalOption('Underline', '􀅓', context),
          _buildModalOption('Strikethrough', '􀅔', context),
          _buildModalOption('Highlight', '􀈎', context),
        ],
      ),
    );
  }
  
  void _showChecklistModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Checklist Options',
        [
          _buildModalOption('Add Checklist', '􀷾', context),
          _buildModalOption('Bulleted List', '􀋲', context),
          _buildModalOption('Numbered List', '􀋱', context),
        ],
      ),
    );
  }
  
  void _showTableModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Table Options',
        [
          _buildModalOption('Insert Table', '􀏣', context),
          _buildModalOption('Add Row', '􀏤', context),
          _buildModalOption('Add Column', '􀏥', context),
        ],
      ),
    );
  }
  
  void _showLayoutModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Layout Options',
        [
          _buildModalOption('Add Layout', '􀏩', context),
          _buildModalOption('Two Columns', '􀏪', context),
          _buildModalOption('Three Columns', '􀏫', context),
        ],
      ),
    );
  }
  
  void _showStackModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Stack Options',
        [
          _buildModalOption('Add Stack', '􀏱', context),
          _buildModalOption('Group Items', '􀏲', context),
          _buildModalOption('Ungroup', '􀏳', context),
        ],
      ),
    );
  }
  
  void _showBrainModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'AI Options',
        [
          _buildModalOption('Summarize', '􀯏', context),
          _buildModalOption('Generate Ideas', '􀯐', context),
          _buildModalOption('Improve Writing', '􀯑', context),
        ],
      ),
    );
  }
  
  void _showPhotoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'Photo Options',
        [
          _buildModalOption('Take Photo', '􀎤', context),
          _buildModalOption('Choose from Library', '􀏅', context),
          _buildModalOption('Photo Bank', '􀏆', context),
        ],
      ),
    );
  }
  
  void _showMoreToolsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildModal(
        context,
        'More Tools',
        [
          _buildModalOption('Drawing', '􀎒', context),
          _buildModalOption('Voice Note', '􀊰', context),
          _buildModalOption('Location', '􀋑', context),
          _buildModalOption('Link', '􀉣', context),
        ],
      ),
    );
  }
  
  Widget _buildModal(BuildContext context, String title, List<Widget> options) {
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
          
          // Modal title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 20),
          
          // Modal options
          ...options,
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  
  Widget _buildModalOption(String title, String icon, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              icon,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'SF Pro Text',
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
} 