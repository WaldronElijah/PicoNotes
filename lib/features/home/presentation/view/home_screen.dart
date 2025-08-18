import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/utils/design_scale.dart';
import '../../../note_editor/presentation/view/note_editor_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000), // Near-black background
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.line_horizontal_3,
            color: Colors.white,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: const Text(
          'Pico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontFamily: 'SF Pro',
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false, // tab bar / FAB already gives bottom affordance
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Notes Section with Carousel
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Grey divider between Pico and Recent
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: DS.s(context, 20),
                      vertical: DS.s(context, 8),
                    ),
                    height: 1,
                    decoration: BoxDecoration(
                      color: const Color(0xFF3C3C3E),
                      borderRadius: BorderRadius.circular(DS.s(context, 0.5)),
                    ),
                  ),
                  
                  // Recent section
                  _buildNotesSection(),
                ],
              ),
            ),

            // Saved Section
            SliverToBoxAdapter(
              child: _buildSavedSection(),
            ),
            
            // Forked Section
            SliverToBoxAdapter(
              child: _buildForkedSection(),
            ),
            
            // Folders Section
            SliverToBoxAdapter(
              child: _buildFoldersSection(),
            ),
            
            // Bottom spacing for FAB
            SliverToBoxAdapter(
              child: SizedBox(height: DS.s(context, 60)), // Reduced from 80 to 60 for minimal dead space
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToNoteEditor('New Note'),
        backgroundColor: const Color(0xFF3375F8),
        child: const Icon(
          CupertinoIcons.plus,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
  
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: DS.s(context, 20), vertical: DS.s(context, 16)),
      height: DS.s(context, 36),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.circular(DS.s(context, 10)),
      ),
      child: Row(
        children: [
          SizedBox(width: DS.s(context, 12)),
          Icon(
            CupertinoIcons.search,
            color: const Color(0xFF8E8E93),
            size: DS.s(context, 16),
          ),
          SizedBox(width: DS.s(context, 8)),
          Text(
            'Search notes...',
            style: TextStyle(
              color: const Color(0xFF8E8E93),
              fontSize: DS.sp(context, 14),
              fontFamily: 'SF Pro',
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionSeparator() {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: DS.s(context, 20),
        vertical: DS.s(context, 16), // Reduced from 24 to 16 for tighter vertical spacing
      ),
      height: 1,
      decoration: BoxDecoration(
        color: const Color(0xFF3C3C3E),
        borderRadius: BorderRadius.circular(DS.s(context, 0.5)),
      ),
    );
  }
  
  Widget _buildNotesSection() {
    return Column(
      children: [
        // Section header positioned over the previews
        Container(
          padding: EdgeInsets.only(
            left: DS.s(context, 32), // Increased from 20 to 32 to push title further right
            bottom: DS.s(context, 16),
          ),
          child: Row(
            children: [
              Text(
                'Recent',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DS.sp(context, 22),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement see all functionality
                },
                child: Text(
                  'see all',
                  style: TextStyle(
                    color: const Color(0xFF3375F8), // Blue color
                    fontSize: DS.sp(context, 16),
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Swiping Carousel with PageView
        Container(
          padding: EdgeInsets.symmetric(horizontal: DS.s(context, 20)),
          child: _buildNotesCarousel(),
        ),
        
        // Section separator
        _buildSectionSeparator(),
      ],
    );
  }
  
  Widget _buildNotesCarousel() {
    final hp = DS.s(context, 18);
    final gap = DS.s(context, 12); // Reduced from 14 to 12 for slightly tighter row spacing
    
    final w = MediaQuery.of(context).size.width;
    final cardW = (w - (hp * 2) - gap) / 2; // 2 columns
    
    // Calculate text height from actual font metrics with extra padding
    final textH = (DS.sp(context, 16) * 1.2)  // title line-height
                 + (DS.sp(context, 14) * 1.2)   // date line-height
                 + DS.s(context, 4)             // between lines
                 + DS.s(context, 16);           // increased bottom pad from 12 to 16
    
    final spacing = DS.s(context, 8); // Reduced from 12 to 8 for tighter image-to-text spacing
    final cardH = cardW + spacing + textH;
    final pageH = (cardH * 2 + gap).ceilToDouble(); // 2 rows per page, rounded up
    
    return SizedBox(
      height: pageH,
      child: PageView.builder(
        itemCount: 2, // 2 pages
        padEnds: false, // Remove default padding
        controller: PageController(
          viewportFraction: 0.95, // Reduced to 95% for more subtle 5% peeking effect
        ),
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * 4;
          final titles = ['Zoo', 'Trip to NYC', 'Ideas', 'Project Notes', 'Journal', 'Recipes', 'Sea Turtle', 'Golden Light'];
          final dates = ['August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025'];
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: DS.s(context, 8)), // Add horizontal padding between pages
            child: Column(
              children: [
                // First row
                SizedBox(
                  height: cardH,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNoteCard(
                          startIndex < titles.length ? titles[startIndex] : 'Empty',
                          startIndex < dates.length ? dates[startIndex] : 'No date',
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        child: _buildNoteCard(
                          startIndex + 1 < titles.length ? titles[startIndex + 1] : 'Empty',
                          startIndex + 1 < dates.length ? dates[startIndex + 1] : 'No date',
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: gap),
                // Second row
                SizedBox(
                  height: cardH,
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildNoteCard(
                          startIndex + 2 < titles.length ? titles[startIndex + 2] : 'Empty',
                          startIndex + 2 < dates.length ? dates[startIndex + 2] : 'No date',
                        ),
                      ),
                      SizedBox(width: gap),
                      Expanded(
                        child: _buildNoteCard(
                          startIndex + 3 < titles.length ? titles[startIndex + 3] : 'No date',
                          startIndex + 3 < dates.length ? dates[startIndex + 3] : 'No date',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildNoteCard(String title, String date) {
    final r = DS.s(context, 4); // Reduced from 16 to 4 for very subtle rounded edges
    final spacing = DS.s(context, 6); // Reduced from 12 to 6 for tighter image-to-text spacing
    
    return GestureDetector(
      onTap: () => _navigateToNoteEditor(title),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: DS.s(context, 8),
              offset: Offset(0, DS.s(context, 4)),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Square preview using AspectRatio
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(r),
                    topRight: Radius.circular(r),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(r),
                    topRight: Radius.circular(r),
                  ),
                  child: title == 'Zoo' 
                    ? Image.asset(
                        'media/windows95image.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue.withOpacity(0.6),
                              Colors.purple.withOpacity(0.6),
                              Colors.teal.withOpacity(0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            CupertinoIcons.doc_text,
                            color: Colors.white,
                            size: DS.s(context, 40),
                          ),
                        ),
                      ),
                ),
              ),
            ),
            SizedBox(height: spacing),
            
            // Natural-height text block (no fixed height)
            Padding(
              padding: EdgeInsets.only(top: DS.s(context, 0)), // Remove horizontal padding, keep only top
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: DS.sp(context, 16),
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro',
                    ),
                  ),
                  SizedBox(height: DS.s(context, 4)),
                  Text(
                    date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.2),
                    style: TextStyle(
                      color: const Color(0xFF8E8E93),
                      fontSize: DS.sp(context, 14),
                      fontFamily: 'SF Pro',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: DS.s(context, 6)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSavedSection() {
    return Column(
      children: [
        // Section header positioned over the previews
        Container(
          padding: EdgeInsets.only(
            left: DS.s(context, 32), // Increased from 20 to 32 to push title further right
            bottom: DS.s(context, 16),
          ),
          child: Row(
            children: [
              Text(
                'Saved',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DS.sp(context, 22),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement see all functionality
                },
                child: Text(
                  'see all',
                  style: TextStyle(
                    color: const Color(0xFF3375F8), // Blue color
                    fontSize: DS.sp(context, 16),
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Saved items carousel with peeking
        Container(
          padding: EdgeInsets.symmetric(horizontal: DS.s(context, 20)),
          child: _buildSavedCarousel(),
        ),
        
        // Section separator
        _buildSectionSeparator(),
      ],
    );
  }
  
  Widget _buildSavedCarousel() {
    final hp = DS.s(context, 18);
    final gap = DS.s(context, 16);
    
    final w = MediaQuery.of(context).size.width;
    final cardW = (w - (hp * 2) - gap) / 2;
    
    final textH = (DS.sp(context, 16) * 1.2) + (DS.sp(context, 14) * 1.2) + DS.s(context, 4) + DS.s(context, 16);
    final spacing = DS.s(context, 8);
    final cardH = cardW + spacing + textH;
    
    return SizedBox(
      height: cardH,
      child: PageView.builder(
        itemCount: 2, // 2 pages for saved items
        padEnds: false,
        controller: PageController(
          viewportFraction: 0.95, // 5% peeking effect
        ),
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * 2;
          final titles = ['Sea Turtle', 'Golden Light', 'Saved Note 3', 'Saved Note 4'];
          final dates = ['August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025'];
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: DS.s(context, 8)),
            child: Row(
              children: [
                Expanded(
                  child: _buildNoteCard(
                    startIndex < titles.length ? titles[startIndex] : 'Empty',
                    startIndex < dates.length ? dates[startIndex] : 'No date',
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: _buildNoteCard(
                    startIndex + 1 < titles.length ? titles[startIndex + 1] : 'Empty',
                    startIndex + 1 < dates.length ? dates[startIndex + 1] : 'No date',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildForkedSection() {
    return Column(
      children: [
        // Section header positioned over the previews
        Container(
          padding: EdgeInsets.only(
            left: DS.s(context, 32), // Increased from 20 to 32 to push title further right
            bottom: DS.s(context, 16),
          ),
          child: Row(
            children: [
              Text(
                'Forked',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DS.sp(context, 22),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement see all functionality
                },
                child: Text(
                  'see all',
                  style: TextStyle(
                    color: const Color(0xFF3375F8), // Blue color
                    fontSize: DS.sp(context, 16),
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Forked items carousel with peeking
        Container(
          padding: EdgeInsets.symmetric(horizontal: DS.s(context, 20)),
          child: _buildForkedCarousel(),
        ),
        
        // Section separator
        _buildSectionSeparator(),
      ],
    );
  }
  
  Widget _buildForkedCarousel() {
    final hp = DS.s(context, 18);
    final gap = DS.s(context, 16);
    
    final w = MediaQuery.of(context).size.width;
    final cardW = (w - (hp * 2) - gap) / 2;
    
    final textH = (DS.sp(context, 16) * 1.2) + (DS.sp(context, 14) * 1.2) + DS.s(context, 4) + DS.s(context, 16);
    final spacing = DS.s(context, 8);
    final cardH = cardW + spacing + textH;
    
    return SizedBox(
      height: cardH,
      child: PageView.builder(
        itemCount: 2, // 2 pages for forked items
        padEnds: false,
        controller: PageController(
          viewportFraction: 0.95, // 5% peeking effect
        ),
        itemBuilder: (context, pageIndex) {
          final startIndex = pageIndex * 2;
          final titles = ['Forked Note 1', 'Forked Note 2', 'Forked Note 3', 'Forked Note 4'];
          final dates = ['August 30, 2025', 'August 30, 2025', 'August 30, 2025', 'August 30, 2025'];
          
          return Container(
            padding: EdgeInsets.symmetric(horizontal: DS.s(context, 8)),
            child: Row(
              children: [
                Expanded(
                  child: _buildNoteCard(
                    startIndex < titles.length ? titles[startIndex] : 'Empty',
                    startIndex < dates.length ? dates[startIndex] : 'No date',
                  ),
                ),
                SizedBox(width: gap),
                Expanded(
                  child: _buildNoteCard(
                    startIndex + 1 < titles.length ? titles[startIndex + 1] : 'Empty',
                    startIndex + 1 < dates.length ? dates[startIndex + 1] : 'No date',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  Widget _buildFoldersSection() {
    return Column(
      children: [
        // Section header positioned over the previews
        Container(
          padding: EdgeInsets.only(
            left: DS.s(context, 20),
            bottom: DS.s(context, 16),
          ),
          child: Row(
            children: [
              Text(
                'Folders',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: DS.sp(context, 22),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'SF Pro',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // TODO: Implement see all functionality
                },
                child: Text(
                  'see all',
                  style: TextStyle(
                    color: const Color(0xFF3375F8), // Blue color
                    fontSize: DS.sp(context, 16),
                    fontFamily: 'SF Pro',
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Folders list
        Container(
          padding: EdgeInsets.symmetric(horizontal: DS.s(context, 20)),
          child: Column(
            children: [
              _buildFolderItem('All Notes', CupertinoIcons.doc_text, 24),
              _buildFolderItem('Work', CupertinoIcons.briefcase, 8),
              _buildFolderItem('Personal', CupertinoIcons.heart, 12),
              _buildFolderItem('Ideas', CupertinoIcons.lightbulb, 6),
              _buildFolderItem('Archive', CupertinoIcons.archivebox, 15),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildFolderItem(String title, IconData icon, int count) {
    return GestureDetector(
      onTap: () => _navigateToFolder(title),
      child: Container(
        margin: EdgeInsets.only(bottom: DS.s(context, 8)),
        padding: EdgeInsets.symmetric(
          horizontal: DS.s(context, 16),
          vertical: DS.s(context, 12),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(DS.s(context, 10)),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF3375F8),
              size: DS.s(context, 20),
            ),
            SizedBox(width: DS.s(context, 12)),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: DS.sp(context, 16),
                fontWeight: FontWeight.w500,
                fontFamily: 'SF Pro',
              ),
            ),
            const Spacer(),
            Text(
              '$count',
              style: TextStyle(
                color: const Color(0xFF8E8E93),
                fontSize: DS.sp(context, 14),
                fontFamily: 'SF Pro',
              ),
            ),
            SizedBox(width: DS.s(context, 4)),
            Icon(
              CupertinoIcons.chevron_right,
              color: const Color(0xFF8E8E93),
              size: DS.s(context, 14),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToNoteEditor(String title) {
    print('Navigate to note editor: $title');
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NoteEditorScreen(),
      ),
    );
  }
  
  void _navigateToFolder(String folderName) {
    print('Navigate to folder: $folderName');
    // TODO: Implement folder navigation
  }
  
  void _showCreateNoteModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CreateNoteModal(),
    );
  }
}

class CreateNoteModal extends StatefulWidget {
  const CreateNoteModal({super.key});

  @override
  State<CreateNoteModal> createState() => _CreateNoteModalState();
}

class _CreateNoteModalState extends State<CreateNoteModal> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createNote() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a title')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Insert note into database
      await Supabase.instance.client
          .from('notes')
          .insert({
            'title': _titleController.text.trim(),
            'content': _contentController.text.trim(),
            'user_id': user.id,
          });

      print('✅ Note created successfully!');
      
      // Close modal and refresh
      Navigator.of(context).pop();
      
      // TODO: Refresh the notes list
      
    } catch (e) {
      print('❌ Error creating note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create note: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(DS.s(context, 20)),
          topRight: Radius.circular(DS.s(context, 20)),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: DS.s(context, 20),
        right: DS.s(context, 20),
        top: DS.s(context, 20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: DS.s(context, 36),
            height: DS.s(context, 5),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(DS.s(context, 2.5)),
            ),
          ),
          SizedBox(height: DS.s(context, 20)),
          
          // Title
          Text(
            'Create New Note',
            style: TextStyle(
              color: Colors.white,
              fontSize: DS.sp(context, 20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: DS.s(context, 20)),
          
          // Title input
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Note title',
              hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
              filled: true,
              fillColor: const Color(0xFF1C1C1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.s(context, 10)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: DS.s(context, 16)),
          
          // Content input
          TextField(
            controller: _contentController,
            style: const TextStyle(color: Colors.white),
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Note content (optional)',
              hintStyle: const TextStyle(color: Color(0xFF8E8E93)),
              filled: true,
              fillColor: const Color(0xFF1C1C1E),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(DS.s(context, 10)),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: DS.s(context, 20)),
          
          // Create button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _createNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3375F8),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: DS.s(context, 16)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DS.s(context, 10)),
                ),
              ),
              child: _isLoading
                  ? SizedBox(
                      height: DS.s(context, 20),
                      width: DS.s(context, 20),
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Create Note',
                      style: TextStyle(
                        fontSize: DS.sp(context, 16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
          SizedBox(height: DS.s(context, 20)),
        ],
      ),
    );
  }
} 