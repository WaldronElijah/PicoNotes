import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SideDrawer extends ConsumerWidget {
  const SideDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      backgroundColor: const Color(0xFF1C1C1E),
      child: SafeArea(
        child: Column(
          children: [
            // Header section
            _buildHeader(),
            
            // Search bar
            _buildSearchBar(),
            
            // Folders section
            Expanded(
              child: Column(
                children: [
                  // Folders title
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: const Row(
                      children: [
                        Text(
                          'Folders',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SF Pro Text',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Folders list
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        _buildFolderItem(
                          icon: CupertinoIcons.star,
                          title: 'Favorites',
                          count: 12,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.briefcase,
                          title: 'Work',
                          count: 8,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.heart,
                          title: 'Personal',
                          count: 15,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.lightbulb,
                          title: 'Ideas',
                          count: 6,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.book,
                          title: 'Research',
                          count: 23,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.bag,
                          title: 'Shopping',
                          count: 4,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.archivebox,
                          title: 'Archive',
                          count: 45,
                          onTap: () => Navigator.pop(context),
                        ),
                        _buildFolderItem(
                          icon: CupertinoIcons.trash,
                          title: 'Recently Deleted',
                          count: 3,
                          onTap: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom action buttons
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // App branding
          const Text(
            'PicoNotes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              fontFamily: 'SF Pro Text',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFF3C3C3E),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.search,
            color: Color(0xFF8E8E93),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'SF Pro Text',
              ),
              decoration: InputDecoration(
                hintText: 'Search notes...',
                hintStyle: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 16,
                  fontFamily: 'SF Pro Text',
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFolderItem({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF3375F8),
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'SF Pro Text',
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 14,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            CupertinoIcons.chevron_right,
            color: Color(0xFF8E8E93),
            size: 14,
          ),
        ],
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1C1C1E),
        border: Border(
          top: BorderSide(
            color: Color(0xFF3C3C3E),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action buttons row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: CupertinoIcons.folder_badge_plus,
                label: 'New Folder',
                onTap: () => _showNewFolderDialog(),
              ),
              _buildActionButton(
                icon: CupertinoIcons.plus_circle,
                label: 'New Note',
                onTap: () => _createNewNote(),
              ),
              _buildActionButton(
                icon: CupertinoIcons.arrow_up_arrow_down,
                label: 'Sort',
                onTap: () => _showSortOptions(),
              ),
              _buildActionButton(
                icon: CupertinoIcons.eye,
                label: 'View Only',
                onTap: () => _toggleViewOnlyMode(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 10,
              fontFamily: 'SF Pro Text',
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showNewFolderDialog() {
    // TODO: Implement new folder dialog
  }

  void _createNewNote() {
    // TODO: Implement new note creation
  }

  void _showSortOptions() {
    // TODO: Implement sort options modal
  }

  void _openSearch() {
    // TODO: Implement search functionality
  }

  void _toggleViewOnlyMode() {
    // TODO: Implement view-only mode toggle
  }
} 