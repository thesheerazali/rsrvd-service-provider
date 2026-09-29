import 'dart:convert';

import 'user_membership.dart';

/// User document shape (mirrors Firebase `users/{uid}` later).
///
/// Auth identity is always [uid] (Firebase Auth). [providerId] is a public
/// viewing code (`RSP-XXXX`) written once at signup — not used for login.
///
/// [membership] is the embedded plan / subscription block used by Home and
/// the choose-plan flow (gateway-agnostic — see [UserMembership]).
class AppUser {
  const AppUser({
    required this.uid,
    required this.providerId,
    required this.displayName,
    required this.email,
    this.occupation = '',
    this.membership = UserMembership.empty,
  });

  /// Firebase Auth UID — login / security.
  final String uid;

  /// Public viewing id on the user doc — e.g. `RSP-0041`.
  final String providerId;

  final String displayName;
  final String email;
  final String occupation;

  /// Current membership / plan snapshot on the user doc.
  final UserMembership membership;

  /// Initials for avatar placeholder (e.g. `Alexander Reyes` → `AR`).
  String get initials {
    final parts = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) {
      final w = parts.first;
      return w.substring(0, w.length.clamp(0, 2)).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    final membershipRaw = json['membership'];
    return AppUser(
      uid: json['uid'] as String? ?? '',
      providerId: json['provider_id'] as String? ??
          json['rsp_id'] as String? ??
          '',
      displayName: json['display_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      occupation: json['occupation'] as String? ?? '',
      membership: UserMembership.fromJson(
        membershipRaw is Map
            ? Map<String, dynamic>.from(membershipRaw)
            : null,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'provider_id': providerId,
        'display_name': displayName,
        'email': email,
        'occupation': occupation,
        'membership': membership.toJson(),
      };

  AppUser copyWith({
    String? displayName,
    String? email,
    String? occupation,
    UserMembership? membership,
  }) {
    return AppUser(
      uid: uid,
      providerId: providerId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      occupation: occupation ?? this.occupation,
      membership: membership ?? this.membership,
    );
  }

  String encode() => jsonEncode(toJson());

  static AppUser? tryDecode(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw);
      if (map is! Map) return null;
      return AppUser.fromJson(Map<String, dynamic>.from(map));
    } catch (_) {
      return null;
    }
  }
}
