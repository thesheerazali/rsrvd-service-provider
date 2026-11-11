/// Selectable boost package — same selection pattern as [MembershipPlan].
class ServiceBoostPlan {
  const ServiceBoostPlan({
    required this.id,
    required this.title,
    required this.description,
    this.recommended = false,
  });

  final String id;

  /// e.g. `3 DAYS - $297`
  final String title;
  final String description;
  final bool recommended;

  static const List<ServiceBoostPlan> catalog = [
    ServiceBoostPlan(
      id: 'boost_3d',
      title: r'3 Days - $297',
      description:
          'Appear on top of search results in your category for 3 days',
    ),
    ServiceBoostPlan(
      id: 'boost_7d',
      title: r'7 Days - $649',
      description:
          'Appear on top of search results in your category for 7 days',
      recommended: true,
    ),
    ServiceBoostPlan(
      id: 'boost_14d',
      title: r'14 Days - $1,199',
      description:
          'Appear on top of search results in your category for 14 days',
    ),
  ];
}
