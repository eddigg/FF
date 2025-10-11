import 'package:equatable/equatable.dart';

class UserIdentity extends Equatable {
  final String address;
  final String username;
  final String email;
  final UserProfile profile;
  final List<Credential> credentials;
  final List<Attestation> attestations;
  final PrivacySettings privacySettings;
  final KYCInfo kyc;
  final ReputationScore reputation;
  final ActivityMetrics activity;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;

  const UserIdentity({
    required this.address,
    required this.username,
    required this.email,
    required this.profile,
    required this.credentials,
    required this.attestations,
    required this.privacySettings,
    required this.kyc,
    required this.reputation,
    required this.activity,
    required this.createdAt,
    required this.updatedAt,
    required this.isActive,
  });

  factory UserIdentity.fromJson(Map<String, dynamic> json) {
    var credentialsList = json['credentials'] as List?;
    List<Credential> credentials = credentialsList != null
        ? credentialsList.map((c) => Credential.fromJson(c)).toList()
        : [];

    var attestationsList = json['attestations'] as List?;
    List<Attestation> attestations = attestationsList != null
        ? attestationsList.map((a) => Attestation.fromJson(a)).toList()
        : [];

    return UserIdentity(
      address: json['address'] as String,
      username: json['username'] as String,
      email: json['email'] as String,
      profile: UserProfile.fromJson(json['profile']),
      credentials: credentials,
      attestations: attestations,
      privacySettings: PrivacySettings.fromJson(json['privacy_settings']),
      kyc: KYCInfo.fromJson(json['kyc']),
      reputation: ReputationScore.fromJson(json['reputation']),
      activity: ActivityMetrics.fromJson(json['activity']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isActive: json['is_active'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'username': username,
      'email': email,
      'profile': profile.toJson(),
      'credentials': credentials.map((c) => c.toJson()).toList(),
      'attestations': attestations.map((a) => a.toJson()).toList(),
      'privacy_settings': privacySettings.toJson(),
      'kyc': kyc.toJson(),
      'reputation': reputation.toJson(),
      'activity': activity.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
    };
  }

  UserIdentity copyWith({
    String? address,
    String? username,
    String? email,
    UserProfile? profile,
    List<Credential>? credentials,
    List<Attestation>? attestations,
    PrivacySettings? privacySettings,
    KYCInfo? kyc,
    ReputationScore? reputation,
    ActivityMetrics? activity,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
  }) {
    return UserIdentity(
      address: address ?? this.address,
      username: username ?? this.username,
      email: email ?? this.email,
      profile: profile ?? this.profile,
      credentials: credentials ?? this.credentials,
      attestations: attestations ?? this.attestations,
      privacySettings: privacySettings ?? this.privacySettings,
      kyc: kyc ?? this.kyc,
      reputation: reputation ?? this.reputation,
      activity: activity ?? this.activity,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [
        address,
        username,
        email,
        profile,
        credentials,
        attestations,
        privacySettings,
        kyc,
        reputation,
        activity,
        createdAt,
        updatedAt,
        isActive,
      ];
}

class UserProfile extends Equatable {
  final String displayName;
  final String bio;
  final String avatar;
  final String location;
  final bool isPublic;

  const UserProfile({
    required this.displayName,
    required this.bio,
    required this.avatar,
    required this.location,
    required this.isPublic,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      displayName: json['display_name'] as String,
      bio: json['bio'] as String,
      avatar: json['avatar'] as String,
      location: json['location'] as String,
      isPublic: json['is_public'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'display_name': displayName,
      'bio': bio,
      'avatar': avatar,
      'location': location,
      'is_public': isPublic,
    };
  }

  @override
  List<Object?> get props => [displayName, bio, avatar, location, isPublic];
}

class Credential extends Equatable {
  final String id;
  final String type;
  final String issuer;
  final String subject;
  final Map<String, dynamic> data;
  final DateTime issuedAt;
  final bool isRevoked;

  const Credential({
    required this.id,
    required this.type,
    required this.issuer,
    required this.subject,
    required this.data,
    required this.issuedAt,
    required this.isRevoked,
  });

  factory Credential.fromJson(Map<String, dynamic> json) {
    return Credential(
      id: json['id'] as String,
      type: json['type'] as String,
      issuer: json['issuer'] as String,
      subject: json['subject'] as String,
      data: json['data'] as Map<String, dynamic>,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      isRevoked: json['is_revoked'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'issuer': issuer,
      'subject': subject,
      'data': data,
      'issued_at': issuedAt.toIso8601String(),
      'is_revoked': isRevoked,
    };
  }

  @override
  List<Object?> get props => [id, type, issuer, subject, data, issuedAt, isRevoked];
}

class Attestation extends Equatable {
  final String id;
  final String attester;
  final String subject;
  final String claim;
  final Map<String, dynamic> data;
  final DateTime issuedAt;
  final DateTime expiresAt;
  final bool isValid;

  const Attestation({
    required this.id,
    required this.attester,
    required this.subject,
    required this.claim,
    required this.data,
    required this.issuedAt,
    required this.expiresAt,
    required this.isValid,
  });

  factory Attestation.fromJson(Map<String, dynamic> json) {
    return Attestation(
      id: json['id'] as String,
      attester: json['attester'] as String,
      subject: json['subject'] as String,
      claim: json['claim'] as String,
      data: json['data'] as Map<String, dynamic>,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      expiresAt: DateTime.parse(json['expires_at'] as String),
      isValid: json['is_valid'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attester': attester,
      'subject': subject,
      'claim': claim,
      'data': data,
      'issued_at': issuedAt.toIso8601String(),
      'expires_at': expiresAt.toIso8601String(),
      'is_valid': isValid,
    };
  }

  @override
  List<Object?> get props => [
        id,
        attester,
        subject,
        claim,
        data,
        issuedAt,
        expiresAt,
        isValid,
      ];
}

class PrivacySettings extends Equatable {
  final String profileVisibility;
  final String activityVisibility;
  final String transactionPrivacy;
  final String contactVisibility;
  final bool locationSharing;
  final String dataRetention;
  final bool gdprConsent;
  final bool marketingConsent;

  const PrivacySettings({
    required this.profileVisibility,
    required this.activityVisibility,
    required this.transactionPrivacy,
    required this.contactVisibility,
    required this.locationSharing,
    required this.dataRetention,
    required this.gdprConsent,
    required this.marketingConsent,
  });

  factory PrivacySettings.fromJson(Map<String, dynamic> json) {
    return PrivacySettings(
      profileVisibility: json['profile_visibility'] as String,
      activityVisibility: json['activity_visibility'] as String,
      transactionPrivacy: json['transaction_privacy'] as String,
      contactVisibility: json['contact_visibility'] as String,
      locationSharing: json['location_sharing'] as bool,
      dataRetention: json['data_retention'] as String,
      gdprConsent: json['gdpr_consent'] as bool,
      marketingConsent: json['marketing_consent'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profile_visibility': profileVisibility,
      'activity_visibility': activityVisibility,
      'transaction_privacy': transactionPrivacy,
      'contact_visibility': contactVisibility,
      'location_sharing': locationSharing,
      'data_retention': dataRetention,
      'gdpr_consent': gdprConsent,
      'marketing_consent': marketingConsent,
    };
  }

  @override
  List<Object?> get props => [
        profileVisibility,
        activityVisibility,
        transactionPrivacy,
        contactVisibility,
        locationSharing,
        dataRetention,
        gdprConsent,
        marketingConsent,
      ];
}

class KYCInfo extends Equatable {
  final String level;
  final bool verified;
  final DateTime? verificationDate;
  final List<String> documents;

  const KYCInfo({
    required this.level,
    required this.verified,
    this.verificationDate,
    required this.documents,
  });

  factory KYCInfo.fromJson(Map<String, dynamic> json) {
    var documentsList = json['documents'] as List?;
    List<String> documents = documentsList != null
        ? documentsList.map((d) => d as String).toList()
        : [];

    return KYCInfo(
      level: json['level'] as String,
      verified: json['verified'] as bool,
      verificationDate: json['verification_date'] != null
          ? DateTime.parse(json['verification_date'] as String)
          : null,
      documents: documents,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'level': level,
      'verified': verified,
      'verification_date':
          verificationDate?.toIso8601String(),
      'documents': documents,
    };
  }

  @override
  List<Object?> get props => [
        level,
        verified,
        verificationDate,
        documents,
      ];
}

class ReputationScore extends Equatable {
  final double overall;
  final double commerce;
  final DateTime lastUpdated;

  const ReputationScore({
    required this.overall,
    required this.commerce,
    required this.lastUpdated,
  });

  factory ReputationScore.fromJson(Map<String, dynamic> json) {
    return ReputationScore(
      overall: (json['overall'] as num).toDouble(),
      commerce: (json['commerce'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['last_updated'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall': overall,
      'commerce': commerce,
      'last_updated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [overall, commerce, lastUpdated];
}

class ActivityMetrics extends Equatable {
  final int postsCreated;
  final int commentsMade;
  final int likesGiven;
  final int likesReceived;
  final int transactions;
  final int proposalsCreated;
  final int votesCast;
  final DateTime lastActive;
  final int streakDays;
  final int totalTokensEarned;

  const ActivityMetrics({
    required this.postsCreated,
    required this.commentsMade,
    required this.likesGiven,
    required this.likesReceived,
    required this.transactions,
    required this.proposalsCreated,
    required this.votesCast,
    required this.lastActive,
    required this.streakDays,
    required this.totalTokensEarned,
  });

  factory ActivityMetrics.fromJson(Map<String, dynamic> json) {
    return ActivityMetrics(
      postsCreated: json['posts_created'] as int,
      commentsMade: json['comments_made'] as int,
      likesGiven: json['likes_given'] as int,
      likesReceived: json['likes_received'] as int,
      transactions: json['transactions'] as int,
      proposalsCreated: json['proposals_created'] as int,
      votesCast: json['votes_cast'] as int,
      lastActive: DateTime.parse(json['last_active'] as String),
      streakDays: json['streak_days'] as int,
      totalTokensEarned: json['total_tokens_earned'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'posts_created': postsCreated,
      'comments_made': commentsMade,
      'likes_given': likesGiven,
      'likes_received': likesReceived,
      'transactions': transactions,
      'proposals_created': proposalsCreated,
      'votes_cast': votesCast,
      'last_active': lastActive.toIso8601String(),
      'streak_days': streakDays,
      'total_tokens_earned': totalTokensEarned,
    };
  }

  @override
  List<Object?> get props => [
        postsCreated,
        commentsMade,
        likesGiven,
        likesReceived,
        transactions,
        proposalsCreated,
        votesCast,
        lastActive,
        streakDays,
        totalTokensEarned,
      ];
}
