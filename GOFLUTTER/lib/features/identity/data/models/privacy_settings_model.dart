import 'package:equatable/equatable.dart';

class PrivacySettingsModel extends Equatable {
  final bool profileVisibility;
  final bool activityVisibility;
  final bool allowDirectMessages;
  final bool showOnlineStatus;
  final bool dataSharing;
  final bool analyticsTracking;
  final bool marketingEmails;
  final bool thirdPartySharing;

  const PrivacySettingsModel({
    required this.profileVisibility,
    required this.activityVisibility,
    required this.allowDirectMessages,
    required this.showOnlineStatus,
    required this.dataSharing,
    required this.analyticsTracking,
    required this.marketingEmails,
    required this.thirdPartySharing,
  });

  @override
  List<Object> get props => [
        profileVisibility,
        activityVisibility,
        allowDirectMessages,
        showOnlineStatus,
        dataSharing,
        analyticsTracking,
        marketingEmails,
        thirdPartySharing,
      ];

  factory PrivacySettingsModel.fromJson(Map<String, dynamic> json) {
    return PrivacySettingsModel(
      profileVisibility: json['profileVisibility'] ?? false,
      activityVisibility: json['activityVisibility'] ?? false,
      allowDirectMessages: json['allowDirectMessages'] ?? false,
      showOnlineStatus: json['showOnlineStatus'] ?? false,
      dataSharing: json['dataSharing'] ?? false,
      analyticsTracking: json['analyticsTracking'] ?? false,
      marketingEmails: json['marketingEmails'] ?? false,
      thirdPartySharing: json['thirdPartySharing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileVisibility': profileVisibility,
      'activityVisibility': activityVisibility,
      'allowDirectMessages': allowDirectMessages,
      'showOnlineStatus': showOnlineStatus,
      'dataSharing': dataSharing,
      'analyticsTracking': analyticsTracking,
      'marketingEmails': marketingEmails,
      'thirdPartySharing': thirdPartySharing,
    };
  }
}