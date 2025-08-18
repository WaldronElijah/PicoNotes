import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'custom_modals.dart';

class NoteEditorToolbar extends StatelessWidget {
  const NoteEditorToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Color(0xFF323233),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Format button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.textformat,
            onTap: () => CustomModals.showFormatModal(context),
          ),
          
          // 2. Checklist button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.check_mark_circled,
            onTap: () => CustomModals.showChecklistModal(context),
          ),
          
          // 3. Table button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.table,
            onTap: () => CustomModals.showTableModal(context),
          ),
          
          // 4. Photo gallery bank button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.photo,
            onTap: () => CustomModals.showMediaModal(context),
          ),
          
          // 5. Carousel button (layout)
          _buildToolbarIconButton(
            context,
            CupertinoIcons.plus_rectangle_on_rectangle,
            onTap: () => CustomModals.showCarouselModal(context),
          ),
          
          // 6. Stack button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.rectangle_stack_badge_plus,
            onTap: () => CustomModals.showStackModal(context),
          ),
          
          // 7. AI button
          _buildToolbarIconButton(
            context,
            CupertinoIcons.lightbulb,
            onTap: () => _showBrainModal(context),
          ),
          
          // 8. X button (close/dismiss)
          _buildToolbarIconButton(
            context,
            CupertinoIcons.xmark,
            onTap: () => FocusScope.of(context).unfocus(),
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
  
  Widget _buildToolbarIconButton(
    BuildContext context,
    IconData icon, {
    Color? color,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        alignment: Alignment.center,
        child: Icon(
          icon,
          color: color ?? Colors.white,
          size: 20,
        ),
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
          _buildModalIconOption('Summarize', CupertinoIcons.doc_text, context),
          _buildModalIconOption('Generate Ideas', CupertinoIcons.lightbulb, context),
          _buildModalIconOption('Improve Writing', CupertinoIcons.pencil_outline, context),
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
  
  Widget _buildModalIconOption(String title, IconData icon, BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 17,
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