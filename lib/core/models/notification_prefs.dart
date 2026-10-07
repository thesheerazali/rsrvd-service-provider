/// Partner notification preference toggles — Elite Settings content.
class NotificationPrefs {
  const NotificationPrefs({
    this.newMemberMessages = true,
    this.contractActivity = false,
    this.paymentsAndReleases = true,
    this.projectStatusUpdates = true,
    this.membershipAndRenewals = false,
  });

  final bool newMemberMessages;
  final bool contractActivity;
  final bool paymentsAndReleases;
  final bool projectStatusUpdates;
  final bool membershipAndRenewals;

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) {
    return NotificationPrefs(
      newMemberMessages: json['new_member_messages'] as bool? ?? true,
      contractActivity: json['contract_activity'] as bool? ?? false,
      paymentsAndReleases: json['payments_and_releases'] as bool? ?? true,
      projectStatusUpdates: json['project_status_updates'] as bool? ?? true,
      membershipAndRenewals: json['membership_and_renewals'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'new_member_messages': newMemberMessages,
        'contract_activity': contractActivity,
        'payments_and_releases': paymentsAndReleases,
        'project_status_updates': projectStatusUpdates,
        'membership_and_renewals': membershipAndRenewals,
      };

  NotificationPrefs copyWith({
    bool? newMemberMessages,
    bool? contractActivity,
    bool? paymentsAndReleases,
    bool? projectStatusUpdates,
    bool? membershipAndRenewals,
  }) {
    return NotificationPrefs(
      newMemberMessages: newMemberMessages ?? this.newMemberMessages,
      contractActivity: contractActivity ?? this.contractActivity,
      paymentsAndReleases: paymentsAndReleases ?? this.paymentsAndReleases,
      projectStatusUpdates: projectStatusUpdates ?? this.projectStatusUpdates,
      membershipAndRenewals:
          membershipAndRenewals ?? this.membershipAndRenewals,
    );
  }
}
