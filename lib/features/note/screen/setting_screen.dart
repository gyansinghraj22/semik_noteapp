import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    this.showBottomNavigation = true,
    this.onDone,
    this.onProfile,
    this.onMasterPassphrase,
    this.onExport,
    this.onLogOut,
    this.onDeleteAccount,
    this.onThemeChanged,
    this.onFontChanged,
    this.onCloudSyncChanged,
    this.onWifiOnlyChanged,
    this.onBiometricChanged,
    this.onTabSelected,
  });

  final bool showBottomNavigation;
  final VoidCallback? onDone;
  final VoidCallback? onProfile;
  final VoidCallback? onMasterPassphrase;
  final VoidCallback? onExport;
  final VoidCallback? onLogOut;
  final VoidCallback? onDeleteAccount;
  final ValueChanged<ThemeMode>? onThemeChanged;
  final ValueChanged<String>? onFontChanged;
  final ValueChanged<bool>? onCloudSyncChanged;
  final ValueChanged<bool>? onWifiOnlyChanged;
  final ValueChanged<bool>? onBiometricChanged;
  final ValueChanged<int>? onTabSelected;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Set<String> selectedFilters = {};

  bool _cloudSync = true;
  bool _wifiOnly = true;
  bool _biometric = true;
  ThemeMode _theme = ThemeMode.light;
  String _font = 'Plus Jakarta Sans';

  final List<String> filterChips = const [
    "All",
    "General",
    "Security",
    "Account",
  ];

  void _action(VoidCallback? callback, String label) {
    if (callback != null) {
      callback();
      return;
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$label is not connected yet.')));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Text(
                          "Settings",
                          maxLines: 1,
                          style: TextStyle(
                            letterSpacing: 0.6,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                            fontSize: 28,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: widget.onDone ?? () => Navigator.maybePop(context),
                        child: const Text(
                          "Done",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Subtitle
                  const Text(
                    "Manage your account preferences and application settings",
                    maxLines: 1,
                    style: TextStyle(color: Colors.black54, fontSize: 10),
                  ),

                  const SizedBox(height: 16),

                  // Search bar
                  SearchBar(
                    hintText: "Search settings...",
                    leading: const Icon(Icons.search),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Horizontal filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: filterChips.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            avatar: const Icon(Icons.tune, size: 16),
                            label: Text(filter),
                            selected: selectedFilters.contains(filter),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedFilters.add(filter);
                                } else {
                                  selectedFilters.remove(filter);
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                // Profile Card
                Card(
                  elevation: 0,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: const CircleAvatar(
                      radius: 24,
                      child: Text("AR"),
                    ),
                    title: const Text(
                      "Alex Rivera",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text("alex.rivera@atelier.design"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _action(widget.onProfile, 'Profile'),
                  ),
                ),

                const SizedBox(height: 16),

                // General & Cloud Sync
                const Text(
                  "GENERAL & CLOUD SYNC",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Cloud Sync"),
                        secondary: const Icon(Icons.cloud_sync_outlined),
                        value: _cloudSync,
                        onChanged: (val) {
                          setState(() => _cloudSync = val);
                          widget.onCloudSyncChanged?.call(val);
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text("Sync on Wi-Fi Only"),
                        secondary: const Icon(Icons.wifi),
                        value: _wifiOnly,
                        onChanged: (val) {
                          setState(() => _wifiOnly = val);
                          widget.onWifiOnlyChanged?.call(val);
                        },
                      ),
                      const Divider(height: 1),
                      const ListTile(
                        leading: Icon(Icons.storage_outlined),
                        title: Text("Storage Used"),
                        trailing: Text(
                          "1.2 GB / 15 GB",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Security & Vault
                const Text(
                  "SECURITY & VAULT",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text("Biometric Lock (Face ID)"),
                        secondary: const Icon(Icons.fingerprint),
                        value: _biometric,
                        onChanged: (val) {
                          setState(() => _biometric = val);
                          widget.onBiometricChanged?.call(val);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.key_outlined),
                        title: const Text("Master Passphrase"),
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Configured", style: TextStyle(color: Colors.grey)),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => _action(
                          widget.onMasterPassphrase,
                          'Master passphrase',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Account & Data
                const Text(
                  "ACCOUNT & DATA",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  elevation: 0,
                  color: Colors.grey.shade50,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.file_download_outlined),
                        title: const Text("Export Notes (.zip)"),
                        trailing: const Icon(Icons.north_east),
                        onTap: () => _action(widget.onExport, 'Export notes'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Log Out"),
                        onTap: () => _action(widget.onLogOut, 'Log out'),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(CupertinoIcons.trash, color: Colors.red),
                        title: const Text(
                          "Delete Account",
                          style: TextStyle(color: Colors.red),
                        ),
                        onTap: () => _action(
                          widget.onDeleteAccount,
                          'Delete account',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const Center(
                  child: Text(
                    "ATELIER NOTES V2.4.0 · ENCRYPTED",
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}