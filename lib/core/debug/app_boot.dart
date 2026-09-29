/// Debug boot switch — flip [splashTarget] while developing.
///
/// Production / default: [BootTarget.session]
/// (signed out → welcome, signed in → home).
enum BootTarget {
  /// Respect local session (correct product behavior).
  session,

  /// Always open Welcome after splash (auth UI work).
  welcome,

  /// Always open Home / main shell after splash (shell UI work).
  home,
}

abstract class AppBoot {
  AppBoot._();

  /// Change this one line to jump splash → welcome or home.
  /// Set back to [BootTarget.session] before release.
  static const BootTarget splashTarget = BootTarget.welcome;
}
