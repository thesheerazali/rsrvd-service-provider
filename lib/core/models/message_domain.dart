/// Vertical / Explore domain a conversation is anchored to.
///
/// Backend should store the same keys on threads (`domain` / `filter_key`)
/// so inbox chips and deep-links stay aligned. See
/// [docs/features/messages.md](../../../../docs/features/messages.md).
enum MessageDomain {
  realEstate,
  investments,
  concierge,
  serviceProviders,
  events,
}

extension MessageDomainX on MessageDomain {
  /// Chip / API filter key.
  String get filterKey => switch (this) {
        MessageDomain.realEstate => 'real_estate',
        MessageDomain.investments => 'investments',
        MessageDomain.concierge => 'concierge',
        MessageDomain.serviceProviders => 'service_providers',
        MessageDomain.events => 'events',
      };

  /// Human label shown in list eyebrows and subject cards.
  String get label => switch (this) {
        MessageDomain.realEstate => 'Real Estate',
        MessageDomain.investments => 'Investments',
        MessageDomain.concierge => 'Concierge',
        MessageDomain.serviceProviders => 'Service Providers',
        MessageDomain.events => 'Events',
      };

  /// GetX route to open when the subject card is tapped (when wired).
  String? get detailRouteHint => switch (this) {
        MessageDomain.realEstate => '/property_detail',
        MessageDomain.investments => '/investment_detail',
        MessageDomain.concierge => '/concierge',
        MessageDomain.serviceProviders => '/service_provider_detail',
        MessageDomain.events => '/event_detail',
      };

  static MessageDomain? fromFilterKey(String? raw) {
    return switch (raw) {
      'real_estate' => MessageDomain.realEstate,
      'investments' => MessageDomain.investments,
      'concierge' => MessageDomain.concierge,
      'service_providers' => MessageDomain.serviceProviders,
      'events' => MessageDomain.events,
      _ => null,
    };
  }
}
