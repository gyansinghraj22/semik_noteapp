import 'package:flutter/material.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  // State Variables
  bool _isPinned = false;
  bool _isStarred = false;
  String _selectedFolder = 'General';
  Color _selectedTint = const Color(0xFFFBF8F5); // Default background tint
  final List<String> _tags = [];
  
  int _characterCount = 0;
  int _wordCount = 0;

  // Available Tint Palette
  final List<Color> _tints = const [
    Color(0xFFFBF8F5), // Default / Cream
    Color(0xFFE8F0FE), // Light Blue
    Color(0xFFE6F4EA), // Light Green
    Color(0xFFFCE8E6), // Light Red/Pink
    Color(0xFFF3E8FD), // Light Purple
  ];

  @override
  void initState() {
    super.initState();
    _bodyController.addListener(_updateCounts);
  }

  void _updateCounts() {
    final text = _bodyController.text;
    setState(() {
      _characterCount = text.length;
      final words = text.trim().split(RegExp(r'\s+'));
      _wordCount = text.trim().isEmpty ? 0 : words.length;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  // Tag Add Dialog
  void _showAddTagDialog() {
    final TextEditingController tagInputController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Tag'),
        content: TextField(
          controller: tagInputController,
          decoration: const InputDecoration(hintText: 'Enter tag name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (tagInputController.text.trim().isNotEmpty) {
                setState(() {
                  _tags.add(tagInputController.text.trim());
                });
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _clearDraft() {
    _titleController.clear();
    _bodyController.clear();
    setState(() {
      _tags.clear();
      _isPinned = false;
      _isStarred = false;
      _selectedTint = _tints[0];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Draft cleared')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _selectedTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            // Handle back navigation
          },
        ),
        title: Row(
          children: [
            const Text(
              'New Note',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFE8E5FB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'SCREEN: Add Note',
                style: TextStyle(
                  color: Color(0xFF5E5CE6),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF4A62D6),
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Sub-header Action Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(Icons.bookmark, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(
                          'Draft · Not saved',
                          style: TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.undo, size: 20, color: Colors.black54),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.redo, size: 20, color: Colors.black54),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      _isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                      size: 20,
                      color: _isPinned ? const Color(0xFF5E5CE6) : Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPinned = !_isPinned;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _isStarred ? Icons.star : Icons.star_border,
                      size: 20,
                      color: _isStarred ? Colors.amber : Colors.black54,
                    ),
                    onPressed: () {
                      setState(() {
                        _isStarred = !_isStarred;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Note Saved!')),
                      );
                    },
                    icon: const Icon(Icons.check, size: 16, color: Colors.white),
                    label: const Text('Done', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B44DB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),
                    // Note Title
                    TextField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Serif',
                        color: Colors.black87,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Note title...',
                        hintStyle: TextStyle(
                          color: Colors.black26,
                          fontFamily: 'Serif',
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Controls Card (Folder, Tint, Tags)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Folder Selector Dropdown
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.05),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedFolder,
                                    isDense: true,
                                    icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                                    items: ['General', 'Work', 'Personal', 'Ideas']
                                        .map((folder) => DropdownMenuItem(
                                              value: folder,
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.folder_outlined, size: 16, color: Colors.black54),
                                                  const SizedBox(width: 6),
                                                  Text(folder, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                                                ],
                                              ),
                                            ))
                                        .toList(),
                                    onChanged: (val) {
                                      if (val != null) setState(() => _selectedFolder = val);
                                    },
                                  ),
                                ),
                              ),
                              const Spacer(),
                              // Tint Palette
                              const Text('Tint: ', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              Row(
                                children: _tints.map((color) {
                                  final isSelected = _selectedTint == color;
                                  return GestureDetector(
                                    onTap: () => setState(() => _selectedTint = color),
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 3),
                                      width: 22,
                                      height: 22,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isSelected ? const Color(0xFF5E5CE6) : Colors.black12,
                                          width: isSelected ? 2 : 1,
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Tags Section
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              const Text('Tags:', style: TextStyle(fontSize: 12, color: Colors.black54)),
                              ..._tags.map((tag) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8E5FB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text('#$tag', style: const TextStyle(fontSize: 11, color: Color(0xFF5E5CE6))),
                                        const SizedBox(width: 4),
                                        GestureDetector(
                                          onTap: () => setState(() => _tags.remove(tag)),
                                          child: const Icon(Icons.close, size: 12, color: Color(0xFF5E5CE6)),
                                        )
                                      ],
                                    ),
                                  )),
                              InkWell(
                                onTap: _showAddTagDialog,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8E5FB),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.add, size: 14, color: Color(0xFF5E5CE6)),
                                      SizedBox(width: 2),
                                      Text(
                                        'Add tag',
                                        style: TextStyle(fontSize: 11, color: Color(0xFF5E5CE6), fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Counters Info Bar
                    Row(
                      children: [
                        const Icon(Icons.short_text, size: 16, color: Colors.black45),
                        const SizedBox(width: 4),
                        Text(
                          '$_characterCount characters · $_wordCount words',
                          style: const TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                        const Spacer(),
                        const Text(
                          'New Note Draft',
                          style: TextStyle(fontSize: 11, color: Colors.black45),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Main Text Area
                    Container(
                      constraints: const BoxConstraints(minHeight: 280),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black12),
                      ),
                      child: TextField(
                        controller: _bodyController,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                        decoration: const InputDecoration(
                          hintText: 'Start typing your note here...',
                          hintStyle: TextStyle(color: Colors.black26),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Footer Actions (Clear draft & Encrypted Vault status)
                    Row(
                      children: [
                        TextButton.icon(
                          onPressed: _clearDraft,
                          icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                          label: const Text(
                            'Clear draft',
                            style: TextStyle(color: Colors.red, fontSize: 12),
                          ),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: const [
                            Icon(Icons.cloud_outlined, size: 14, color: Colors.black45),
                            SizedBox(width: 4),
                            Text(
                              'Encrypted Local Vault',
                              style: TextStyle(fontSize: 11, color: Colors.black45),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Rich Text Formatting Toolbar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildToolbarButton(label: 'B', isBold: true, onTap: () {}),
                  _buildToolbarButton(label: 'I', isItalic: true, onTap: () {}),
                  _buildToolbarButton(label: 'T', isHeader: true, onTap: () {}),
                  const VerticalDivider(width: 12, thickness: 1, indent: 8, endIndent: 8),
                  IconButton(
                    icon: const Icon(Icons.format_list_bulleted, size: 18, color: Colors.black54),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E5FB),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.tune, size: 18, color: Color(0xFF5E5CE6)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.code, size: 18, color: Colors.black54),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  IconButton(
                    icon: const Icon(Icons.image_outlined, size: 18, color: Colors.black54),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_horiz, size: 18, color: Colors.black54),
                    onPressed: () {},
                    constraints: const BoxConstraints(),
                    padding: const EdgeInsets.all(6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolbarButton({
    required String label,
    bool isBold = false,
    bool isItalic = false,
    bool isHeader = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold || isHeader ? FontWeight.bold : FontWeight.normal,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}