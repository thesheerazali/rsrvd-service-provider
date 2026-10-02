/// One chip in an [AppFilterSection].
class AppFilterOption {
  const AppFilterOption({required this.id, required this.label});

  final String id;
  final String label;
}

/// Labeled chip group — Property Type / Category / Sort By, etc.
class AppFilterSection {
  const AppFilterSection({
    required this.id,
    required this.title,
    required this.options,
    this.multiSelect = false,
  });

  final String id;
  final String title;
  final List<AppFilterOption> options;

  /// When false, tapping a chip replaces the section’s selection (radio).
  final bool multiSelect;
}

/// Full filter sheet config — same shell, different sections per screen.
class AppFilterConfig {
  const AppFilterConfig({
    required this.sections,
    this.title = 'Filters & Sorting',
    this.clearLabel = 'Clear All',
  });

  final String title;
  final String clearLabel;
  final List<AppFilterSection> sections;

  /// Figma `1001:2027` — Real Estate filters.
  static const AppFilterConfig realEstate = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'property_type',
        title: 'Property Type',
        options: [
          AppFilterOption(id: 'residential', label: 'Residential'),
          AppFilterOption(id: 'commercial', label: 'Commercial'),
        ],
      ),
      AppFilterSection(
        id: 'category',
        title: 'Category',
        options: [
          AppFilterOption(id: 'villa', label: 'Villa'),
          AppFilterOption(id: 'apartment', label: 'Appartment'),
          AppFilterOption(id: 'office', label: 'Office'),
          AppFilterOption(id: 'penthouse', label: 'Pent House'),
          AppFilterOption(id: 'land', label: 'Land'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'price_asc', label: 'Price ascending'),
          AppFilterOption(id: 'price_desc', label: 'Price descending'),
        ],
      ),
    ],
  );

  static const AppFilterConfig events = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'type',
        title: 'Event Type',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'invite', label: 'Invite only'),
          AppFilterOption(id: 'rsvp', label: 'RSVP'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'soonest', label: 'Soonest'),
          AppFilterOption(id: 'newest', label: 'Newest'),
        ],
      ),
    ],
  );

  static const AppFilterConfig community = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'content',
        title: 'Content',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'photos', label: 'Photos'),
          AppFilterOption(id: 'members', label: 'Members'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'popular', label: 'Most liked'),
        ],
      ),
    ],
  );

  static const AppFilterConfig serviceProviders = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'category',
        title: 'Category',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'travel', label: 'Travel'),
          AppFilterOption(id: 'wellness', label: 'Wellness'),
          AppFilterOption(id: 'lifestyle', label: 'Lifestyle'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'featured', label: 'Featured'),
          AppFilterOption(id: 'rating', label: 'Top rated'),
        ],
      ),
    ],
  );

  static const AppFilterConfig investments = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'category',
        title: 'Category',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'aerospace', label: 'Aerospace'),
          AppFilterOption(id: 'real_estate', label: 'Real Estate'),
          AppFilterOption(id: 'tech', label: 'Tech'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'raise_desc', label: 'Largest raise'),
        ],
      ),
    ],
  );

  static const AppFilterConfig projects = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'status',
        title: 'Status',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'active', label: 'Active'),
          AppFilterOption(id: 'completed', label: 'Completed'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'updated', label: 'Recently updated'),
        ],
      ),
    ],
  );

  static const AppFilterConfig messages = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'domain',
        title: 'Category',
        options: [
          AppFilterOption(id: 'real_estate', label: 'Real Estate'),
          AppFilterOption(id: 'investments', label: 'Investments'),
          AppFilterOption(id: 'concierge', label: 'Concierge'),
          AppFilterOption(id: 'service_providers', label: 'Service Providers'),
          AppFilterOption(id: 'events', label: 'Events'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'unread', label: 'Unread first'),
        ],
      ),
    ],
  );

  /// Partners inbox — Figma Messages filters.
  static const AppFilterConfig partnersMessages = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'status',
        title: 'Status',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'unread', label: 'Unread'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'unread', label: 'Unread first'),
        ],
      ),
    ],
  );

  /// Partners My Services filters.
  static const AppFilterConfig partnersServices = AppFilterConfig(
    sections: [
      AppFilterSection(
        id: 'status',
        title: 'Status',
        options: [
          AppFilterOption(id: 'all', label: 'All'),
          AppFilterOption(id: 'approved', label: 'Approved'),
          AppFilterOption(id: 'pending', label: 'In Review'),
          AppFilterOption(id: 'rejected', label: 'Not Approved'),
        ],
      ),
      AppFilterSection(
        id: 'sort',
        title: 'Sort By',
        options: [
          AppFilterOption(id: 'newest', label: 'Newest'),
          AppFilterOption(id: 'boosted', label: 'Boosted first'),
        ],
      ),
    ],
  );
}

/// Selected chip ids keyed by section id.
typedef AppFilterSelection = Map<String, Set<String>>;
