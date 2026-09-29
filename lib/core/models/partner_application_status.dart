/// Partner application review state (backend-driven once API lands).
///
/// Gatekeeping rule: after submit, the signed-in user may only see the
/// application-status screen until admin sets [approved] / [rejected], or
/// until membership completes ([active] → home).
///
/// See [docs/application-status.md].
enum PartnerApplicationStatus {
  /// Form not submitted yet (or resubmit after reject).
  none,

  /// Submitted — pending admin review.
  submitted,

  /// Admin approved — membership still required.
  approved,

  /// Admin rejected — user may resubmit.
  rejected,

  /// Membership active — full partner home.
  active,
}

extension PartnerApplicationStatusX on PartnerApplicationStatus {
  String get storageValue => name;

  static PartnerApplicationStatus fromStorage(String? raw) {
    if (raw == null || raw.isEmpty) return PartnerApplicationStatus.none;
    return PartnerApplicationStatus.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => PartnerApplicationStatus.none,
    );
  }

  bool get isPendingReview => this == PartnerApplicationStatus.submitted;

  bool get locksToStatusScreen =>
      this == PartnerApplicationStatus.submitted ||
      this == PartnerApplicationStatus.approved ||
      this == PartnerApplicationStatus.rejected;
}
