import 'package:equatable/equatable.dart';

/// Wallet account entity for multi-account support
class WalletAccount extends Equatable {
  final String name;
  final String privateKeyJwk;
  final String publicKeyJwk;
  final String? address;

  const WalletAccount({
    required this.name,
    required this.privateKeyJwk,
    required this.publicKeyJwk,
    this.address,
  });

  /// Creates a copy of the account with updated values
  WalletAccount copyWith({
    String? name,
    String? privateKeyJwk,
    String? publicKeyJwk,
    String? address,
  }) {
    return WalletAccount(
      name: name ?? this.name,
      privateKeyJwk: privateKeyJwk ?? this.privateKeyJwk,
      publicKeyJwk: publicKeyJwk ?? this.publicKeyJwk,
      address: address ?? this.address,
    );
  }

  /// Converts the account to a JSON-serializable map
  Map<String, dynamic> toJson() => {
        'name': name,
        'privateKeyJwk': privateKeyJwk,
        'publicKeyJwk': publicKeyJwk,
        'address': address,
      };

  /// Creates an account from a JSON map
  factory WalletAccount.fromJson(Map<String, dynamic> json) => WalletAccount(
        name: json['name'] as String,
        privateKeyJwk: json['privateKeyJwk'] as String,
        publicKeyJwk: json['publicKeyJwk'] as String,
        address: json['address'] as String?,
      );

  @override
  List<Object?> get props => [name, privateKeyJwk, publicKeyJwk, address];
}