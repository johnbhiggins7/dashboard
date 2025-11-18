import 'package:flutter/material.dart';

/// User-configurable app preferences stored locally.
class UserPreferences {
  final bool pushNotifications;
  final bool emailNotifications;
  final bool smsNotifications;
  final String notificationFrequency; // 'realtime' | 'hourly' | 'daily'
  final bool marketingEmails;
  final bool appSounds;
  final bool doNotDisturb;
  final ThemeMode themeMode; // Redundant with ThemeProvider, shown in UI

  const UserPreferences({
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.notificationFrequency = 'realtime',
    this.marketingEmails = false,
    this.appSounds = true,
    this.doNotDisturb = false,
    this.themeMode = ThemeMode.system,
  });

  UserPreferences copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? smsNotifications,
    String? notificationFrequency,
    bool? marketingEmails,
    bool? appSounds,
    bool? doNotDisturb,
    ThemeMode? themeMode,
  }) {
    return UserPreferences(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      smsNotifications: smsNotifications ?? this.smsNotifications,
      notificationFrequency:
          notificationFrequency ?? this.notificationFrequency,
      marketingEmails: marketingEmails ?? this.marketingEmails,
      appSounds: appSounds ?? this.appSounds,
      doNotDisturb: doNotDisturb ?? this.doNotDisturb,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
