/// Partner notification preference toggles — mirrors Elite `1196:17544` UI.
class NotificationPrefs {
  const NotificationPrefs({
    this.serviceUpdates = true,
    this.newOpportunities = false,
    this.memberRequests = true,
    this.messageUpdates = true,
    this.projectUpdates = false,
    this.reviewRatings = false,
    this.membershipUpdates = true,
    this.accountSecurity = true,
  });

  final bool serviceUpdates;
  final bool newOpportunities;
  final bool memberRequests;
  final bool messageUpdates;
  final bool projectUpdates;
  final bool reviewRatings;
  final bool membershipUpdates;
  final bool accountSecurity;

  factory NotificationPrefs.fromJson(Map<String, dynamic> json) {
    return NotificationPrefs(
      serviceUpdates: json['service_updates'] as bool? ?? true,
      newOpportunities: json['new_opportunities'] as bool? ?? false,
      memberRequests: json['member_requests'] as bool? ?? true,
      messageUpdates: json['message_updates'] as bool? ?? true,
      projectUpdates: json['project_updates'] as bool? ?? false,
      reviewRatings: json['review_ratings'] as bool? ?? false,
      membershipUpdates: json['membership_updates'] as bool? ?? true,
      accountSecurity: json['account_security'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'service_updates': serviceUpdates,
        'new_opportunities': newOpportunities,
        'member_requests': memberRequests,
        'message_updates': messageUpdates,
        'project_updates': projectUpdates,
        'review_ratings': reviewRatings,
        'membership_updates': membershipUpdates,
        'account_security': accountSecurity,
      };

  NotificationPrefs copyWith({
    bool? serviceUpdates,
    bool? newOpportunities,
    bool? memberRequests,
    bool? messageUpdates,
    bool? projectUpdates,
    bool? reviewRatings,
    bool? membershipUpdates,
    bool? accountSecurity,
  }) {
    return NotificationPrefs(
      serviceUpdates: serviceUpdates ?? this.serviceUpdates,
      newOpportunities: newOpportunities ?? this.newOpportunities,
      memberRequests: memberRequests ?? this.memberRequests,
      messageUpdates: messageUpdates ?? this.messageUpdates,
      projectUpdates: projectUpdates ?? this.projectUpdates,
      reviewRatings: reviewRatings ?? this.reviewRatings,
      membershipUpdates: membershipUpdates ?? this.membershipUpdates,
      accountSecurity: accountSecurity ?? this.accountSecurity,
    );
  }
}
