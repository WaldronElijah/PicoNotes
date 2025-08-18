import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class NoteEditorHeader extends StatelessWidget {
  final VoidCallback? onSave;
  final bool isSaving;
  
  const NoteEditorHeader({
    super.key,
    this.onSave,
    this.isSaving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.chevron_left,
                    color: Color(0xFF3375F8),
                    size: 17,
                  ),
                ),
              ),
              
              // Title
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: const Text(
                    'New Note',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'SF Pro Text',
                      letterSpacing: -0.24,
                    ),
                  ),
                ),
              ),
              
              // Save button
              if (onSave != null)
                GestureDetector(
                  onTap: isSaving ? null : onSave,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    child: isSaving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(
                            CupertinoIcons.check_mark,
                            color: Color(0xFF3375F8),
                            size: 17,
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  void _showMoreOptionsModal(BuildContext context) {
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
            
            // Modal options
            _buildModalIconOption('Share Note', CupertinoIcons.share, context),
            _buildModalIconOption('Duplicate', CupertinoIcons.doc_on_doc, context),
            _buildModalIconOption('Delete', CupertinoIcons.delete, context, isDestructive: true),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModalOption(String title, String icon, BuildContext context, {bool isDestructive = false}) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Text(
              icon,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.white,
                fontSize: 17,
                fontFamily: 'SF Pro Text',
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.white,
                fontSize: 17,
                fontFamily: 'SF Pro Text',
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModalIconOption(String title, IconData icon, BuildContext context, {bool isDestructive = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.of(context).pop(),
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 17,
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isDestructive ? Colors.red : Colors.white,
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