import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Navigator observer that logs every push/pop/replace and keeps an in-memory
/// route stack for debugging (e.g. `RouteLogger.history`).
///
/// Register in GetMaterialApp: `navigatorObservers: [RouteLogger()]`.
class RouteLogger extends NavigatorObserver {
  RouteLogger();

  static final List<Route<dynamic>> _routeStack = [];

  static List<String> get routeHistory =>
      _routeStack.map((route) => route.settings.name ?? 'Unknown').toList();

  static String? get currentRoute =>
      _routeStack.isNotEmpty ? _routeStack.last.settings.name : null;

  static String? get previousRoute => _routeStack.length > 1
      ? _routeStack[_routeStack.length - 2].settings.name
      : null;

  static bool get canGoBack => _routeStack.length > 1;

  static String get history => routeHistory.join(' → ');

  static void clearHistory() => _routeStack.clear();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.add(route);
    _log('PUSHED ${_name(route)} (from ${_name(previousRoute)})');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _log('POPPED ${_name(route)} (back to ${_name(previousRoute)})');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _routeStack.remove(route);
    _log('REMOVED ${_name(route)}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) {
      final index = _routeStack.indexOf(oldRoute);
      if (index != -1 && newRoute != null) {
        _routeStack[index] = newRoute;
      } else {
        _routeStack.remove(oldRoute);
      }
    }
    if (newRoute != null && !_routeStack.contains(newRoute)) {
      _routeStack.add(newRoute);
    }
    _log('REPLACED ${_name(oldRoute)} → ${_name(newRoute)}');
  }

  String _name(Route<dynamic>? route) {
    if (route == null) return 'null';
    return route.settings.name ?? route.runtimeType.toString();
  }

  void _log(String message) {
    if (kReleaseMode) return;
    log('NAVIGATION: $message | stack: ${RouteLogger.history}');
  }
}
