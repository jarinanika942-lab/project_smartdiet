import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main.dart'; 

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _supabase = Supabase.instance.client;
  
  bool darkMode = false;
  bool notifications = true;
  bool reminder = true;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

 
  Future<void> _loadUserSettings() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await _supabase
          .from('user_settings')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null && mounted) {
        setState(() {
          darkMode = data['dark_mode'] ?? false;
          notifications = data['notifications'] ?? true;
          reminder = data['meal_reminder'] ?? true;
          
        
          themeNotifier.value = darkMode ? ThemeMode.dark : ThemeMode.light;
        });
      }
    } catch (e) {
      debugPrint("Error loading settings: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  
  Future<void> _updateSetting(String column, bool value) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    setState(() {
      if (column == 'dark_mode') {
        darkMode = value;
        
        themeNotifier.value = value ? ThemeMode.dark : ThemeMode.light;
      }
      if (column == 'notifications') notifications = value;
      if (column == 'meal_reminder') reminder = value;
    });

    try {
      await _supabase.from('user_settings').upsert({
        'id': user.id,
        column: value,
      });
      debugPrint("$column updated to $value");
    } catch (e) {
      _loadUserSettings(); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update: $e"), duration: const Duration(seconds: 1)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
   
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? null : const Color(0xFFF5F7FA), 
      appBar: AppBar(
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSectionTitle("General"),
                _buildSettingCard(
                  title: "Dark Mode",
                  subtitle: "Enable dark theme across the app",
                  icon: Icons.dark_mode,
                  value: darkMode,
                  onChanged: (val) => _updateSetting('dark_mode', val),
                ),
                const SizedBox(height: 12),
                _buildSectionTitle("Notifications"),
                _buildSettingCard(
                  title: "Push Notifications",
                  subtitle: "Get diet and lifestyle reminders",
                  icon: Icons.notifications_active,
                  value: notifications,
                  onChanged: (val) => _updateSetting('notifications', val),
                ),
                _buildSettingCard(
                  title: "Meal Reminder",
                  subtitle: "Receive daily meal tracking notification",
                  icon: Icons.restaurant,
                  value: reminder,
                  onChanged: (val) => _updateSetting('meal_reminder', val),
                ),
                const SizedBox(height: 30),
                const Center(
                  child: Text(
                    "Settings are saved automatically",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Card(
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: SwitchListTile(
        secondary: CircleAvatar(
          backgroundColor: Colors.green.withOpacity(0.1),
          child: Icon(icon, color: Colors.green, size: 20),
        ),
        activeColor: Colors.green,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
      ),
    );
  }
}

