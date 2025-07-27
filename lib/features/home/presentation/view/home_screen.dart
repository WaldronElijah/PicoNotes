import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../note_editor/presentation/view/note_editor_screen.dart';
import '../../../../core/utils/responsive_utils.dart';

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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context), 
        vertical: 16
      ),
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
              Text(
                'PicoNotes',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveUtils.titleFontSize(context),
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
          
          SizedBox(height: ResponsiveUtils.verticalSpacing(context)),
          
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.headingFontSize(context),
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          SizedBox(height: ResponsiveUtils.verticalSpacing(context)),
          
          // Recent notes 2x2 carousel  
          SizedBox(
            height: ResponsiveUtils.carouselHeight(context),
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
          // Note preview image - takes most of the space
          Expanded(
            flex: 5,
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
          
          // Title and date section - fixed height to prevent overflow
          Container(
            height: 36, // Fixed height for text section
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Note title
                Flexible(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.cardTitleFontSize(context),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro Text',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                const SizedBox(height: 2),
                
                // Note date
                Flexible(
                  child: Text(
                    date,
                    style: TextStyle(
                      color: const Color(0xFF8E8E93),
                      fontSize: ResponsiveUtils.cardDateFontSize(context),
                      fontFamily: 'SF Pro Text',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
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
    
    final cardWidth = ResponsiveUtils.cardWidth(context);
    final cardHeight = ResponsiveUtils.cardHeight(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          // First row
          SizedBox(
            height: cardHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFolderNoteCard(
                    startIndex < titles.length ? titles[startIndex] : 'Empty',
                    startIndex < dates.length ? dates[startIndex] : 'No date',
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: cardWidth,
                  height: cardHeight,
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
          SizedBox(
            height: cardHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: cardWidth,
                  height: cardHeight,
                  child: _buildFolderNoteCard(
                    startIndex + 2 < titles.length ? titles[startIndex + 2] : 'Empty',
                    startIndex + 2 < dates.length ? dates[startIndex + 2] : 'No date',
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  width: cardWidth,
                  height: cardHeight,
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Forked Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.headingFontSize(context),
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          SizedBox(height: ResponsiveUtils.verticalSpacing(context)),
          
          // Forked notes 1x1 carousel
          SizedBox(
            height: ResponsiveUtils.singleRowHeight(context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = ['Design Ideas Fork', 'Meeting Notes V2', 'Shopping List Copy'];
                final dates = ['3 days ago', '1 week ago', '2 weeks ago'];
                return Container(
                  width: ResponsiveUtils.horizontalItemWidth(context),
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
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shared',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.headingFontSize(context),
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          SizedBox(height: ResponsiveUtils.verticalSpacing(context)),
          
          // Shared notes 1x1 carousel
          SizedBox(
            height: ResponsiveUtils.singleRowHeight(context),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final titles = ['Team Project', 'Shared Recipe', 'Collaboration Notes'];
                final dates = ['Shared today', 'Shared yesterday', 'Shared 2 days ago'];
                return Container(
                  width: ResponsiveUtils.horizontalItemWidth(context),
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
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context), 
        vertical: ResponsiveUtils.sectionSpacing(context)
      ),
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(0.5),
      ),
    );
  }
  
  Widget _buildFoldersSection() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.horizontalPadding(context)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Folders',
            style: TextStyle(
              color: Colors.white,
              fontSize: ResponsiveUtils.headingFontSize(context),
              fontWeight: FontWeight.w600,
              fontFamily: 'SF Pro Text',
            ),
          ),
          SizedBox(height: ResponsiveUtils.verticalSpacing(context)),
          
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