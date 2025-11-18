import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import '../models/user_preferences.dart';

/// Local persistence for user preferences.
class PreferencesService {
  static const _prefix = 'prefs.';
  static const _kPush = '${_prefix}push';
  static const _kEmail = '${_prefix}email';
  static const _kSms = '${_prefix}sms';
  static const _kFreq = '${_prefix}freq';
  static const _kMarketing = '${_prefix}marketing';
  static const _kSounds = '${_prefix}sounds';
  static const _kDnd = '${_prefix}dnd';
  static const _kTheme = 'app.theme_mode'; // shared with ThemeProvider

  static Future<UserPreferences> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeStr = prefs.getString(_kTheme);
      final themeMode = switch (themeStr) {
        'light' => ThemeMode.light,
        'dark' => ThemeMode.dark,
        _ => ThemeMode.system,
      };
      return UserPreferences(
        pushNotifications: prefs.getBool(_kPush) ?? true,
        emailNotifications: prefs.getBool(_kEmail) ?? true,
        smsNotifications: prefs.getBool(_kSms) ?? false,
        notificationFrequency: prefs.getString(_kFreq) ?? 'realtime',
        marketingEmails: prefs.getBool(_kMarketing) ?? false,
        appSounds: prefs.getBool(_kSounds) ?? true,
        doNotDisturb: prefs.getBool(_kDnd) ?? false,
        themeMode: themeMode,
      );
    } catch (e, st) {
      debugPrint('PreferencesService.load error: $e\n$st');
      return const UserPreferences();
    }
  }

  static Future<void> save(UserPreferences prefsModel) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kPush, prefsModel.pushNotifications);
      await prefs.setBool(_kEmail, prefsModel.emailNotifications);
      await prefs.setBool(_kSms, prefsModel.smsNotifications);
      await prefs.setString(_kFreq, prefsModel.notificationFrequency);
      await prefs.setBool(_kMarketing, prefsModel.marketingEmails);
      await prefs.setBool(_kSounds, prefsModel.appSounds);
      await prefs.setBool(_kDnd, prefsModel.doNotDisturb);
      // Theme is persisted by ThemeProvider, not here (avoid double writes)
    } catch (e, st) {
      debugPrint('PreferencesService.save error: $e\n$st');
    }
  }
}
