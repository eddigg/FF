import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final String username;
  final String fullName;
  final String email;
  final String bio;
  final String location;
  final String website;
  final Map<String, dynamic> socialLinks;
  final String status;
  final String verificationLevel;

  const UserProfileModel({
    required this.username,
    required this.fullName,
    required this.email,
    required this.bio,
    required this.location,
    required this.website,
    required this.socialLinks,
    required this.status,
    required this.verificationLevel,
  });

  @override
  List<Object> get props => [
        username,
        fullName,
        email,
        bio,
        location,
        website,
        socialLinks,
        status,
        verificationLevel,
      ];

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      bio: json['bio'] ?? '',
      location: json['location'] ?? '',
      website: json['website'] ?? '',
      socialLinks: json['socialLinks'] ?? {},
      status: json['status'] ?? '',
      verificationLevel: json['verificationLevel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'email': email,
      'bio': bio,
      'location': location,
      'website': website,
      'socialLinks': socialLinks,
      'status': status,
      'verificationLevel': verificationLevel,
    };
  }
}
