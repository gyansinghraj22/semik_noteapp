import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const _ink = Color(0xFF292720);
const _muted = Color(0xFF827D73);
const _paper = Color(0xFFFAF8F2);
const _panel = Color(0xFFF0EDE6);
const _purple = Color(0xFF7057EB);
const _lavender = Color(0xFFECE7FF);

/// The architecture note shown in the design reference.
class NoteDetailsScreen extends StatefulWidget {
  const NoteDetailsScreen({super.key});

  @override
  State<NoteDetailsScreen> createState() => _NoteDetailsScreenState();
}

class _NoteDetailsScreenState extends State<NoteDetailsScreen> {
  String _title = 'Q3 Mobile Architecture Spec';
  String _summary =
      'This architectural specification outlines the migration path toward an '
      'offline-first, reactive local SQLite persistence engine with a '
      'unidirectional state synchronization layer for iOS and Android clients.';
  bool _favourite = true;
  bool _pinned = true;
  final _completed = [true, true, false];
  final _milestones = [
    'Implement atomic, non-destructive local schema migrations.',
    'Stress test encrypted zero-knowledge ledger across 10,000 mock notes.',
    'Publish final protocol specifications to internal developer portal.',
  ];

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _edit() async {
    final title = TextEditingController(text: _title);
    final summary = TextEditingController(text: _summary);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _paper,
        title: const Text('Edit note'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(labelText: 'Title'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: summary,
                  minLines: 4,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    labelText: 'Executive summary',
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (title.text.trim().isNotEmpty) {
                Navigator.pop(dialogContext, true);
              }
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
    if (saved == true && mounted) {
      setState(() {
        _title = title.text.trim();
        _summary = summary.text.trim();
      });
    }
    // Dialog route animations may still be using the controllers.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    title.dispose();
    summary.dispose();
  }

  Future<void> _share() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: _paper,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Share note', style: TextStyle(fontSize: 22)),
              const SizedBox(height: 8),
              const Text('Copy this note as text to share it with your team.'),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.copy_outlined, color: _purple),
                title: const Text('Copy note'),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: _plainText));
                  if (!sheetContext.mounted) return;
                  Navigator.pop(sheetContext);
                  if (mounted) _message('Note copied to clipboard');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _plainText =>
      '$_title\n\nExecutive Summary\n$_summary\n\n'
      'Core Principles\n'
      'Delta Compaction: Local write-ahead log (WAL) compacts on a '
      'paused activity, with partial reindexing.\n'
      'Memory Budget: Peak resident memory usage under 120 MB on low-tier devices.\n'
      'Conflict Resolution: Last-write-wins with deterministic logical clocks.\n\n'
      'Implementation Milestones\n'
      '${List.generate(_milestones.length, (i) => '${_completed[i] ? '[x]' : '[ ]'} ${_milestones[i]}').join('\n')}';

  Future<void> _confirmAction({required bool delete}) async {
    final action = delete ? 'Delete' : 'Archive';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: _paper,
        title: Text('$action note?'),
        content: Text(
          'This is a design preview. $action will close this preview; '
          'no stored note will be changed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              action,
              style: TextStyle(color: delete ? Colors.red : _purple),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        scaffoldBackgroundColor: _paper,
        colorScheme: ColorScheme.fromSeed(seedColor: _purple, surface: _paper),
        textTheme: Theme.of(context).textTheme
            .apply(fontFamily: 'Poppins', bodyColor: _ink, displayColor: _ink),
        dividerColor: const Color(0xFFE5E0D6),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Column(
                children: [
                  _topBar(),
                  const Divider(height: 1),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _header(),
                          const SizedBox(height: 20),
                          _actions(),
                          const SizedBox(height: 24),
                          const _SectionTitle(
                            '01 / OVERVIEW',
                            'Executive Summary',
                          ),
                          Text(
                            _summary,
                            style: const TextStyle(fontSize: 13, height: 1.85),
                          ),
                          const SizedBox(height: 26),
                          const _SectionTitle(
                            '02 / DATA TOPOLOGY',
                            'Sync Pipeline Geometry',
                          ),
                          _pipeline(),
                          const SizedBox(height: 26),
                          const _SectionTitle(
                            '03 / SPECIFICATIONS',
                            'Core Principles',
                          ),
                          const _Principle(
                            icon: Icons.auto_awesome_outlined,
                            title: 'Delta Compaction',
                            description:
                                'Local write-ahead log (WAL) compacts on a paused activity, '
                                'with partial reindexing to avoid blocking the main thread. '
                                'Subsequent writes remain non-blocking.',
                          ),
                          const _Principle(
                            icon: Icons.memory_outlined,
                            title: 'Memory Budget',
                            description:
                                'Peak resident memory usage under 120 MB on low-tier devices. '
                                'Large attachments page lazily, preserving a fluid typing experience '
                                'even on legacy hardware.',
                          ),
                          const _Principle(
                            icon: Icons.alt_route_rounded,
                            title: 'Conflict Resolution',
                            description:
                                'Last-write-wins with deterministic logical clocks. '
                                'Cryptographic signatures verify payload integrity before local '
                                'ledger commits.',
                          ),
                          const SizedBox(height: 18),
                          const _SectionTitle(
                            '04 / EXECUTION',
                            'Implementation Milestones',
                          ),
                          ...List.generate(_milestones.length, _milestone),
                          const SizedBox(height: 26),
                          const _SectionTitle(
                            '05 / MEDIA & ATTACHMENTS',
                            'Target Hardware Environment',
                          ),
                          _attachment(),
                          const SizedBox(height: 26),
                          const Divider(height: 1),
                          const SizedBox(height: 14),
                          const Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _Meta(Icons.lock_outline, 'End-to-End Encrypted'),
                              _Meta(Icons.cloud_done_outlined, 'Local preview'),
                              Text(
                                'Rev. 1.4',
                                style: TextStyle(fontSize: 10, color: _muted),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  _footer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _topBar() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Back to notes',
          onPressed: () => Navigator.maybePop(context),
          icon: const Icon(Icons.arrow_back, size: 21),
        ),
        Expanded(
          child: Text(
            'WORKSPACE / NOTE DETAILS',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10, letterSpacing: 1.2, color: _muted),
          ),
        ),
        const SizedBox(width: 8),
        const CircleAvatar(
          radius: 17,
          backgroundColor: _purple,
          child: Icon(Icons.person_outline, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 8),
      ],
    ),
  );

  Widget _header() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Wrap(
        spacing: 12,
        runSpacing: 8,
        alignment: WrapAlignment.spaceBetween,
        children: [
          _Badge('DESIGN NOTEBOOK', icon: Icons.folder_outlined, accent: true),
          _Meta(Icons.lock_outline, 'Secured & Synced'),
        ],
      ),
      const SizedBox(height: 14),
      const Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _Badge('Work', icon: Icons.work_outline),
          _Badge('#architecture'),
          _Badge('#mobile'),
          _Badge('#draft'),
        ],
      ),
      const SizedBox(height: 14),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              _title,
              style: const TextStyle(
                fontFamily: 'serif',
                fontSize: 30,
                height: 1.12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _squareIcon(
            _favourite ? Icons.star_rounded : Icons.star_border_rounded,
            'Favourite note',
            () => setState(() => _favourite = !_favourite),
            color: const Color(0xFFC58837),
            background: const Color(0xFFF8EEDA),
          ),
          const SizedBox(width: 6),
          _squareIcon(
            _pinned ? Icons.push_pin : Icons.push_pin_outlined,
            'Pin note',
            () => setState(() => _pinned = !_pinned),
            color: _purple,
            background: _lavender,
          ),
        ],
      ),
      const SizedBox(height: 16),
      const _Meta(
        Icons.calendar_today_outlined,
        'Created Oct 12, 2026, 10:30 AM',
      ),
      const SizedBox(height: 6),
      const _Meta(Icons.update_rounded, 'Updated 2 hours ago'),
      const SizedBox(height: 12),
      Wrap(
        spacing: 14,
        runSpacing: 8,
        children: [
          _Meta(
            Icons.description_outlined,
            '${_plainText.trim().split(RegExp(r'\s+')).length} words · 4 min read',
          ),
          const _Badge(
            'E2E Encrypted',
            icon: Icons.verified_user_outlined,
            accent: true,
          ),
        ],
      ),
    ],
  );

  Widget _squareIcon(
    IconData icon,
    String tooltip,
    VoidCallback onPressed, {
    required Color color,
    required Color background,
  }) => SizedBox(
    width: 34,
    height: 36,
    child: IconButton(
      padding: EdgeInsets.zero,
      style: IconButton.styleFrom(
        backgroundColor: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, color: color, size: 19),
    ),
  );

  Widget _actions() => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      _Action('Edit', Icons.edit_outlined, _edit, primary: true),
      _Action('Share', Icons.ios_share_outlined, _share),
      _Action(
        'Pin note',
        Icons.push_pin_outlined,
        () => setState(() => _pinned = !_pinned),
      ),
      _Action(
        'Delete',
        Icons.delete_outline,
        () => _confirmAction(delete: true),
        danger: true,
      ),
    ],
  );

  Widget _pipeline() => Container(
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFE4DFD4)),
    ),
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Figure 1.0: Reactive Event Sync Pipeline',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 8),
              _Badge(
                'Documentation',
                icon: Icons.account_tree_outlined,
                accent: true,
              ),
            ],
          ),
        ),
        Container(
          color: const Color(0xFFF6F3EC),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
          child: const Row(
            children: [
              Expanded(child: _PipelineNode('Local DB', 'SQLite', false)),
              _Connector(),
              Expanded(child: _PipelineNode('CRDT Sync', 'Event Queue', true)),
              _Connector(),
              Expanded(child: _PipelineNode('Cloud', 'Relay', false)),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'P2P-first, eventual consistency data replication. Mutations '
            'persist in the encrypted device cache before ever leaving the '
            'network boundary.',
            style: TextStyle(
              fontFamily: 'serif',
              fontSize: 12,
              color: _muted,
              height: 1.6,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _milestone(int index) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Material(
      color: _panel,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => setState(() => _completed[index] = !_completed[index]),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5, 8, 12, 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 32,
                height: 28,
                child: Checkbox(
                  value: _completed[index],
                  activeColor: _purple,
                  side: const BorderSide(color: Color(0xFFB7B0A4)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3),
                  ),
                  onChanged: (value) =>
                      setState(() => _completed[index] = value ?? false),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    _milestones[index],
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.65,
                      color: _completed[index] ? _muted : _ink,
                      decoration: _completed[index]
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _attachment() => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(9),
      border: Border.all(color: const Color(0xFFE4DFD4)),
    ),
    child: Column(
      children: [
        InkWell(
          onTap: () => showDialog<void>(
            context: context,
            builder: (dialogContext) => Dialog(
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _HardwarePhoto(),
                  TextButton(
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text('Close'),
                  ),
                ],
              ),
            ),
          ),
          child: Stack(
            children: [
              const _HardwarePhoto(),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.image_outlined, size: 12, color: Colors.white),
                      SizedBox(width: 5),
                      Text(
                        'JPG · 2.4 MB',
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Hardware target: testing environment setup',
                  style: TextStyle(fontFamily: 'serif', fontSize: 13),
                ),
              ),
              SizedBox(width: 12),
              Text(
                'Reference\nOct 2026',
                textAlign: TextAlign.right,
                style: TextStyle(fontSize: 9, color: _muted, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  Widget _footer() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _Action(
          _favourite ? 'Favourited' : 'Favourite',
          _favourite ? Icons.star_rounded : Icons.star_border_rounded,
          () => setState(() => _favourite = !_favourite),
        ),
        _Action(
          'Archive Note',
          Icons.inventory_2_outlined,
          () => _confirmAction(delete: false),
        ),
        _Action(
          'Delete',
          Icons.delete_outline,
          () => _confirmAction(delete: true),
          danger: true,
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.eyebrow, this.title);
  final String eyebrow;
  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          eyebrow,
          style: const TextStyle(
            color: _purple,
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ],
    ),
  );
}

class _Badge extends StatelessWidget {
  const _Badge(this.label, {this.icon, this.accent = false});
  final String label;
  final IconData? icon;
  final bool accent;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
    decoration: BoxDecoration(
      color: accent ? _lavender : _panel,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 11, color: accent ? _purple : _muted),
          const SizedBox(width: 4),
        ],
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: accent ? _purple : _muted,
          ),
        ),
      ],
    ),
  );
}

class _Meta extends StatelessWidget {
  const _Meta(this.icon, this.label);
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(icon, size: 12, color: _muted),
      const SizedBox(width: 5),
      Flexible(
        child: Text(label, style: const TextStyle(fontSize: 10, color: _muted)),
      ),
    ],
  );
}

class _Action extends StatelessWidget {
  const _Action(
    this.label,
    this.icon,
    this.onPressed, {
    this.primary = false,
    this.danger = false,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final bool primary;
  final bool danger;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, size: 15),
    label: Text(label),
    style: TextButton.styleFrom(
      backgroundColor: primary
          ? _purple
          : danger
          ? const Color(0xFFFFE1DD)
          : _panel,
      foregroundColor: primary
          ? Colors.white
          : danger
          ? const Color(0xFFD34E51)
          : _ink,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      minimumSize: const Size(0, 40),
      textStyle: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 11,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    ),
  );
}

class _Principle extends StatelessWidget {
  const _Principle({
    required this.icon,
    required this.title,
    required this.description,
  });
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: _panel,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: _lavender,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Icon(icon, color: _purple, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 11,
                  color: _muted,
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _PipelineNode extends StatelessWidget {
  const _PipelineNode(this.title, this.subtitle, this.highlighted);
  final String title;
  final String subtitle;
  final bool highlighted;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 18),
    decoration: BoxDecoration(
      color: highlighted ? _purple : _paper,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: highlighted ? _purple : const Color(0xFFDED7CA),
      ),
    ),
    child: Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: highlighted ? Colors.white : _ink,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: highlighted ? Colors.white70 : _muted,
          ),
        ),
      ],
    ),
  );
}

class _Connector extends StatelessWidget {
  const _Connector();
  @override
  Widget build(BuildContext context) => const SizedBox(
    width: 28,
    child: Icon(Icons.arrow_forward_rounded, color: _purple, size: 20),
  );
}

/// Displays only the workstation photograph within the supplied reference.
/// Keeps the reference intact and requires no network image dependency.
class _HardwarePhoto extends StatelessWidget {
  const _HardwarePhoto();

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 114 / 55,
    child: ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: 114,
          height: 55,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: -50,
                top: -584,
                width: 253,
                height: 729,
                child: Image.asset(
                  'assets/images/note_design_reference.jpeg',
                  width: 253,
                  height: 729,
                  fit: BoxFit.fill,
                  filterQuality: FilterQuality.high,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}