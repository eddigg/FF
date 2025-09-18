
import 'package:equatable/equatable.dart';

class KycStatusModel extends Equatable {
  final String personalInfoStatus;
  final String? personalInfoDate;
  final String identityDocumentStatus;
  final String? identityDocumentDate;
  final String addressProofStatus;
  final String? addressProofDate;
  final String financialInfoStatus;
  final String? financialInfoDate;
  final String sourceOfFundsStatus;
  final String? sourceOfFundsDate;

  const KycStatusModel({
    required this.personalInfoStatus,
    this.personalInfoDate,
    required this.identityDocumentStatus,
    this.identityDocumentDate,
    required this.addressProofStatus,
    this.addressProofDate,
    required this.financialInfoStatus,
    this.financialInfoDate,
    required this.sourceOfFundsStatus,
    this.sourceOfFundsDate,
  });

  @override
  List<Object> get props => [
        personalInfoStatus,
        identityDocumentStatus,
        addressProofStatus,
        financialInfoStatus,
        sourceOfFundsStatus,
      ];

  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    return KycStatusModel(
      personalInfoStatus: json['personalInfoStatus'] ?? '',
      personalInfoDate: json['personalInfoDate'],
      identityDocumentStatus: json['identityDocumentStatus'] ?? '',
      identityDocumentDate: json['identityDocumentDate'],
      addressProofStatus: json['addressProofStatus'] ?? '',
      addressProofDate: json['addressProofDate'],
      financialInfoStatus: json['financialInfoStatus'] ?? '',
      financialInfoDate: json['financialInfoDate'],
      sourceOfFundsStatus: json['sourceOfFundsStatus'] ?? '',
      sourceOfFundsDate: json['sourceOfFundsDate'],
    );
  }
}
