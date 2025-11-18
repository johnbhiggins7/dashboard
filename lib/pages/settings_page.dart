import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';

import '../models/user_preferences.dart';
import '../services/preferences_service.dart';
import '../theme/theme_provider.dart';
import '../widgets/app_shell.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _loading = true;
  UserPreferences _prefs = const UserPreferences();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final loaded = await PreferencesService.load();
    if (!mounted) return;
    setState(() {
      _prefs = loaded;
      _loading = false;
    });
  }

  Future<void> _save(UserPreferences next) async {
    setState(() => _prefs = next);
    await PreferencesService.save(next);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      pageTitle: 'Settings',
      child:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAppearanceSection(context),
                  const SizedBox(height: 16),
                  _buildNotificationsSection(context),
                  const SizedBox(height: 16),
                  _buildPreferencesSection(context),
                ],
              ),
    );
  }

  Widget _tileTitle(BuildContext context, String text) => Text(
    text,
    style: context.theme.typography.sm.copyWith(
      fontWeight: FontWeight.w600,
      color: context.theme.colors.foreground,
    ),
  );

  Widget _buildAppearanceSection(BuildContext context) {
    final theme = context.theme;
    final provider = context.watch<ThemeProvider>();
    final selected = provider.themeMode;

    return FCard.raw(
      style:
          FCardStyle(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            contentStyle: FCardContentStyle(
              padding: const EdgeInsets.all(16),
              titleTextStyle: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: context.theme.colors.foreground,
              ),
              subtitleTextStyle: context.theme.typography.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ).call,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appearance',
            style: context.theme.typography.sm.copyWith(
              fontWeight: FontWeight.w600,
              color: context.theme.colors.foreground,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose how the app looks and feels',
            style: context.theme.typography.xs.copyWith(
              color: context.theme.colors.mutedForeground,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _themeChoiceChip(
                context,
                'System',
                FIcons.monitor,
                selected == ThemeMode.system,
                () {
                  context.read<ThemeProvider>().setThemeMode(ThemeMode.system);
                  _save(_prefs.copyWith(themeMode: ThemeMode.system));
                },
              ),
              _themeChoiceChip(
                context,
                'Light',
                FIcons.sun,
                selected == ThemeMode.light,
                () {
                  context.read<ThemeProvider>().setThemeMode(ThemeMode.light);
                  _save(_prefs.copyWith(themeMode: ThemeMode.light));
                },
              ),
              _themeChoiceChip(
                context,
                'Dark',
                FIcons.moon,
                selected == ThemeMode.dark,
                () {
                  context.read<ThemeProvider>().setThemeMode(ThemeMode.dark);
                  _save(_prefs.copyWith(themeMode: ThemeMode.dark));
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Tip: You can also switch themes from the header icon.',
            style: theme.typography.xs.copyWith(
              color: theme.colors.mutedForeground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _themeChoiceChip(
    BuildContext context,
    String label,
    IconData icon,
    bool selected,
    VoidCallback onTap,
  ) {
    final theme = context.theme;
    return ChoiceChip(
      selected: selected,
      label: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          Icon(icon, size: 16, color: theme.colors.foreground),
          Text(label, style: theme.typography.sm),
        ],
      ),
      onSelected: (_) => onTap(),
      selectedColor: theme.colors.primary.withValues(alpha: 0.12),
      backgroundColor: theme.colors.muted,
      side: BorderSide(color: theme.colors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    );
  }

  Widget _buildNotificationsSection(BuildContext context) {
    final theme = context.theme;
    return FCard.raw(
      style:
          FCardStyle(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
            ),
            contentStyle: FCardContentStyle(
              padding: const EdgeInsets.all(16),
              titleTextStyle: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: context.theme.colors.foreground,
              ),
              subtitleTextStyle: context.theme.typography.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ).call,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: context.theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Control what you want to be notified about',
                  style: context.theme.typography.xs.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _switchTile(
            context,
            icon: FIcons.bell,
            title: 'Push Notifications',
            value: _prefs.pushNotifications,
            onChanged: (v) => _save(_prefs.copyWith(pushNotifications: v)),
          ),
          const SizedBox(height: 8),
          _switchTile(
            context,
            icon: FIcons.mail,
            title: 'Email Notifications',
            value: _prefs.emailNotifications,
            onChanged: (v) => _save(_prefs.copyWith(emailNotifications: v)),
          ),
          const SizedBox(height: 8),
          _switchTile(
            context,
            icon: FIcons.phone,
            title: 'SMS Notifications',
            value: _prefs.smsNotifications,
            onChanged: (v) => _save(_prefs.copyWith(smsNotifications: v)),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delivery Frequency',
              style: theme.typography.xs.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _freqChip('Real-time', 'realtime'),
              _freqChip('Hourly', 'hourly'),
              _freqChip('Daily', 'daily'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _freqChip(String label, String key) {
    final isSelected = _prefs.notificationFrequency == key;
    return Builder(
      builder: (context) {
        final theme = context.theme;
        return ChoiceChip(
          selected: isSelected,
          label: Text(label, style: theme.typography.sm),
          onSelected: (_) => _save(_prefs.copyWith(notificationFrequency: key)),
          selectedColor: theme.colors.primary.withValues(alpha: 0.12),
          backgroundColor: theme.colors.muted,
          side: BorderSide(color: theme.colors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        );
      },
    );
  }

  Widget _buildPreferencesSection(BuildContext context) {
    return FCard.raw(
      style:
          FCardStyle(
            decoration: BoxDecoration(
              color: context.theme.colors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            contentStyle: FCardContentStyle(
              padding: const EdgeInsets.all(16),
              titleTextStyle: context.theme.typography.sm.copyWith(
                fontWeight: FontWeight.w600,
                color: context.theme.colors.foreground,
              ),
              subtitleTextStyle: context.theme.typography.xs.copyWith(
                color: context.theme.colors.mutedForeground,
              ),
            ),
          ).call,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Preferences',
                  style: context.theme.typography.sm.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.theme.colors.foreground,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Fine-tune sounds and marketing messages',
                  style: context.theme.typography.xs.copyWith(
                    color: context.theme.colors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _switchTile(
            context,
            icon: FIcons.volume2,
            title: 'App Sounds',
            value: _prefs.appSounds,
            onChanged: (v) => _save(_prefs.copyWith(appSounds: v)),
          ),
          const SizedBox(height: 8),
          _switchTile(
            context,
            icon: FIcons.moon,
            title: 'Do Not Disturb',
            value: _prefs.doNotDisturb,
            onChanged: (v) => _save(_prefs.copyWith(doNotDisturb: v)),
          ),
          const SizedBox(height: 8),
          _switchTile(
            context,
            icon: FIcons.mailOpen,
            title: 'Marketing Emails',
            value: _prefs.marketingEmails,
            onChanged: (v) => _save(_prefs.copyWith(marketingEmails: v)),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = context.theme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colors.mutedForeground),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.typography.sm.copyWith(
                color: theme.colors.foreground,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: theme.colors.primary,
          ),
        ],
      ),
    );
  }
}
