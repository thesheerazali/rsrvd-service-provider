import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/styles/app_colors.dart';
import 'headless/focus_handler.dart';

/// Standard screen scaffold for the app.
///
/// Handles the status-bar style, background color, optional keyboard
/// dismissal on outside taps, safe area, and back-press interception —
/// so views only describe their content.
class AppScreen extends StatelessWidget {
  const AppScreen({
    super.key,
    required this.child,
    this.padding = EdgeInsets.zero,
    this.keyboardHandler = false,
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,
    this.backgroundColor,
    this.appBar,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.onBackPressed,
    this.canPop = true,
    this.lightStatusBar = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool keyboardHandler;
  final bool resizeToAvoidBottomInset;
  final bool safeArea;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final VoidCallback? onBackPressed;
  final bool canPop;
  final bool lightStatusBar;

  @override
  Widget build(BuildContext context) {
    var body = Padding(padding: padding, child: child) as Widget;

    if (keyboardHandler) {
      body = FocusHandler(child: body);
    }
    if (safeArea) {
      body = SafeArea(child: body);
    }
    if (onBackPressed != null || !canPop) {
      body = PopScope(
        canPop: canPop && onBackPressed == null,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) onBackPressed?.call();
        },
        child: body,
      );
    }

    final overlayStyle = lightStatusBar
        ? SystemUiOverlayStyle.light.copyWith(
            statusBarBrightness: Brightness.dark,
            statusBarIconBrightness: Brightness.light,
          )
        : SystemUiOverlayStyle.dark.copyWith(
            statusBarBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
          );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        backgroundColor: backgroundColor ?? AppColors.bg,
        appBar: appBar,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        body: body,
      ),
    );
  }
}
