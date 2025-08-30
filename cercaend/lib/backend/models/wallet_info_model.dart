class AppWalletInfo {
  final String address;
  final int balance;
  final int nonce;
  final bool isValidator;

  AppWalletInfo({
    required this.address,
    required this.balance,
    required this.nonce,
    required this.isValidator,
  });

  factory AppWalletInfo.fromJson(Map<String, dynamic> json) {
    // The actual API returns the wallet info inside a 'data' object.
    final data = json['data'];
    return AppWalletInfo(
      address: data['address'] ?? '',
      balance: data['balance'] ?? 0,
      nonce: data['nonce'] ?? 0,
      isValidator: data['isValidator'] ?? false,
    );
  }
}
