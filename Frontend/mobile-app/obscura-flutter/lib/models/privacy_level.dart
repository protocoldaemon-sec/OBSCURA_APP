enum PrivacyLevel { transparent, shielded, compliant }

extension PrivacyLevelExtension on PrivacyLevel {
  String get displayName {
    switch (this) {
      case PrivacyLevel.shielded:
        return 'Shielded';
      case PrivacyLevel.compliant:
        return 'Compliant';
      case PrivacyLevel.transparent:
        return 'Transparent';
    }
  }

  String get emoji {
    switch (this) {
      case PrivacyLevel.shielded:
        return '🛡️';
      case PrivacyLevel.compliant:
        return '📋';
      case PrivacyLevel.transparent:
        return '🔓';
    }
  }
}
