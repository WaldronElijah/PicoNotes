import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NoteEditorHeader extends StatelessWidget {
  const NoteEditorHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E).withOpacity(0.76),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Column(
        children: [
          // Status bar area
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time
                const Text(
                  '9:41',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro',
                    letterSpacing: -0.5,
                  ),
                ),
                
                // Status indicators
                Row(
                  children: [
                    // Signal bars
                    Container(
                      width: 20,
                      height: 12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: 3,
                            height: 4 + (index * 2).toDouble(),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 5),
                    
                    // WiFi icon
                    const Icon(
                      Icons.wifi,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    
                    // Battery
                    Container(
                      width: 24,
                      height: 11,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 16,
                          height: 7,
                          margin: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                    // Battery tip
                    Container(
                      width: 2,
                      height: 4,
                      margin: const EdgeInsets.only(left: 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Navigation and title section
          Expanded(
            child: Padding(
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
                      child: const Text(
                        '􀆉', // SF Symbol: chevron.left
                        style: TextStyle(
                          color: Color(0xFF3375F8),
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                        ),
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
                  
                  // More options button
                  GestureDetector(
                    onTap: () {
                      // Show more options modal
                      _showMoreOptionsModal(context);
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      child: const Text(
                        '􀍠', // SF Symbol: ellipsis.circle
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'SF Pro Text',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            _buildModalOption('Share Note', '􀈂', context),
            _buildModalOption('Duplicate', '􀉁', context),
            _buildModalOption('Delete', '􀈑', context, isDestructive: true),
            
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
} 