class AppStatus {
  final int blockHeight;
  final int txPoolSize;
  final bool isValidator;
  final String validatorAddress;
  final int totalValidators;

  AppStatus({
    required this.blockHeight,
    required this.txPoolSize,
    required this.isValidator,
    required this.validatorAddress,
    required this.totalValidators,
  });

  factory AppStatus.fromJson(Map<String, dynamic> json) {
    return AppStatus(
      blockHeight: json['blockHeight'] ?? 0,
      txPoolSize: json['txPoolSize'] ?? 0,
      isValidator: json['isValidator'] ?? false,
      validatorAddress: json['validatorAddress'] ?? '',
      totalValidators: json['totalValidators'] ?? 0,
    );
  }
}
