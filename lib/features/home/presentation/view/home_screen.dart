import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../note_editor/presentation/view/note_editor_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Header section
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            
            // Recent notes section (2x2 carousel)
            SliverToBoxAdapter(
              child: _buildRecentNotesSection(),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: _buildDivider(),
            ),
            
            // Forked notes section (1x1 carousel)
            SliverToBoxAdapter(
              child: _buildForkedNotesSection(),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: _buildDivider(),
            ),
            
            // Shared section (1x1 carousel)
            SliverToBoxAdapter(
              child: _buildSharedSection(),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: _buildDivider(),
            ),
            
            // Folders section
            SliverToBoxAdapter(
              child: _buildFoldersSection(),
            ),
            
            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          // Brand icon and title
          Row(
            children: [
              // Hamburger menu button
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    CupertinoIcons.line_horizontal_3,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'PicoNotes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'SF Pro Text',
                ),
              ),
              const Spacer(),
              // Profile/Settings button
              GestureDetector(
                onTap: () => _showProfileModal(),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C2E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    CupertinoIcons.person_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Search bar
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              children: [
                SizedBox(width: 12),
                Icon(
                  CupertinoIcons.search,
                  color: Color(0xFF8E8E93),
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Search notes...',
                  style: TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 14,
                    fontFamily: 'SF Pro Text',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRecentNotesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 16),
          
          // Recent notes 2x2 carousel  
          SizedBox(
            height: 420,
            child: PageView.builder(
              itemCount: 2, // 2 pages
              itemBuilder: (context, pageIndex) {
                return _build2x2NotesGrid(pageIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFolderNoteCard(String title, String date) {
    return GestureDetector(
      onTap: () => _navigateToNoteEditor(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Note preview image - fills the entire card
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue.withOpacity(0.4),
                    Colors.purple.withOpacity(0.4),
                    Colors.teal.withOpacity(0.4),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.doc_text,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Title and date section - outside the image card
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Note title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'SF Pro Text',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                const SizedBox(height: 2),
                
                // Note date
                Text(
                  date,
                  style: const TextStyle(
                    color: Color(0xFF8E8E93),
                    fontSize: 12,
                    fontFamily: 'SF Pro Text',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _build2x2NotesGrid(int pageIndex) {
    final startIndex = pageIndex * 4;
    final titles = ['Meeting Notes', 'Shopping List', 'Ideas', 'Travel Plan', 'Recipes', 'Journal', 'Project Notes', 'Todo List'];
    final dates = ['Today', 'Yesterday', '2 days ago', 'Last week', 'Last month', '2 weeks ago', '3 days ago', 'Today'];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // First row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildFolderNoteCard(
                    startIndex < titles.length ? titles[startIndex] : 'Empty',
                    startIndex < dates.length ? dates[startIndex] : 'No date',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFolderNoteCard(
                    startIndex + 1 < titles.length ? titles[startIndex + 1] : 'Empty',
                    startIndex + 1 < dates.length ? dates[startIndex + 1] : 'No date',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Second row
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildFolderNoteCard(
                    startIndex + 2 < titles.length ? titles[startIndex + 2] : 'Empty',
                    startIndex + 2 < dates.length ? dates[startIndex + 2] : 'No date',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildFolderNoteCard(
                    startIndex + 3 < titles.length ? titles[startIndex + 3] : 'Empty',
                    startIndex + 3 < dates.length ? dates[startIndex + 3] : 'No date',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildForkedNotesSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Forked Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 16),
          
          // Forked notes 1x1 carousel
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = ['Design Ideas Fork', 'Meeting Notes V2', 'Shopping List Copy'];
                final dates = ['3 days ago', '1 week ago', '2 weeks ago'];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildFolderNoteCard(titles[index], dates[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSharedSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shared',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 16),
          
          // Shared notes 1x1 carousel
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = ['Team Project', 'Shared Recipe', 'Collaboration Notes'];
                final dates = ['Shared today', 'Shared yesterday', 'Shared 2 days ago'];
                return Container(
                  width: 180,
                  margin: const EdgeInsets.only(right: 12),
                  child: _buildFolderNoteCard(titles[index], dates[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
  
  Widget _buildFoldersSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Folders',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          const SizedBox(height: 16),
          
          // Folders list
          _buildFolderItem('All Notes', CupertinoIcons.doc_text, 24),
          _buildFolderItem('Work', CupertinoIcons.briefcase, 8),
          _buildFolderItem('Personal', CupertinoIcons.heart, 12),
          _buildFolderItem('Ideas', CupertinoIcons.lightbulb, 6),
          _buildFolderItem('Archive', CupertinoIcons.archivebox, 15),
        ],
      ),
    );
  }
  
  Widget _buildFolderItem(String title, IconData icon, int count) {
    return GestureDetector(
      onTap: () => _navigateToFolder(title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3375F8),
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
            const Spacer(),
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
      ),
    );
  }
  

  
  void _navigateToNoteEditor() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NoteEditorScreen(),
      ),
    );
  }
  

  
  void _navigateToFolder(String folderName) {
    // TODO: Implement folder navigation
  }
  
  void _showProfileModal() {
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
            
            _buildModalOption('Settings', CupertinoIcons.gear),
            _buildModalOption('Backup & Sync', CupertinoIcons.cloud),
            _buildModalOption('Export Notes', CupertinoIcons.square_arrow_up),
            _buildModalOption('Help & Support', CupertinoIcons.question_circle),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModalOption(String title, IconData icon) {
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