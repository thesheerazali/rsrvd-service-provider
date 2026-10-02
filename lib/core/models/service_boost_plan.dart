/// Selectable boost package — same selection pattern as [MembershipPlan].
class ServiceBoostPlan {
  const ServiceBoostPlan({
    required this.id,
    required this.title,
    required this.description,
  });

  final String id;

  /// e.g. `$50 FOR 24 HOURS BOOST`
  final String title;
  final String description;

  static const List<ServiceBoostPlan> catalog = [
    ServiceBoostPlan(
      id: 'boost_24h',
      title: r'$50 FOR 24 HOURS BOOST',
      description:
          'Appear on top of search results in your category for 24 hours',
    ),
    ServiceBoostPlan(
      id: 'boost_4d',
      title: r'$150 FOR 4 DAYS BOOST',
      description:
          'Appear on top of search results in your category for 4 days',
    ),
    ServiceBoostPlan(
      id: 'boost_7d',
      title: r'$250 FOR 7 DAYS BOOST',
      description:
          'Appear on top of search results in your category for 7 days',
    ),
  ];
}
