import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/foundation.dart';

/// Severity levels for [AppLog], each mapped to an ANSI color for readable
/// console output.
enum AppLogLevel {
  debug('\x1B[37m'), // White
  info('\x1B[36m'), // Cyan
  warning('\x1B[33m'), // Yellow
  error('\x1B[31m'); // Red

  const AppLogLevel(this.colorCode);

  final String colorCode;
}

/// Lightweight logging utility. Logs are silenced in release builds.
///
/// Usage:
///   AppLog.d('Splash init');
///   AppLog.e('Login failed', error: e, stackTrace: s);
class AppLog {
  AppLog._();

  static const bool _enableColors = true;

  static void d(Object? message, {String tag = 'APP'}) =>
      _log(message, tag: tag, level: AppLogLevel.debug);

  static void i(Object? message, {String tag = 'APP'}) =>
      _log(message, tag: tag, level: AppLogLevel.info);

  static void w(Object? message, {String tag = 'APP'}) =>
      _log(message, tag: tag, level: AppLogLevel.warning);

  static void e(
    Object? message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) =>
      _log(
        message,
        tag: tag,
        level: AppLogLevel.error,
        error: error,
        stackTrace: stackTrace,
      );

  static void _log(
    Object? message, {
    required String tag,
    required AppLogLevel level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) return;

    final useColor = _enableColors && _supportsAnsiColors;
    final color = useColor ? level.colorCode : '';
    final reset = useColor ? '\x1B[0m' : '';
    final time = DateTime.now().toIso8601String();

    developer.log(
      '$color[$tag] $time $message$reset',
      name: level.name.toUpperCase(),
      error: error,
      stackTrace: stackTrace,
    );
  }

  static bool get _supportsAnsiColors {
    try {
      return stdout.supportsAnsiEscapes;
    } catch (_) {
      return false;
    }
  }
}
