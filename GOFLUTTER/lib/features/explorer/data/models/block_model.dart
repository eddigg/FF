
import 'package:equatable/equatable.dart';

class BlockModel extends Equatable {
  final int index;
  final String hash;
  final String prevHash;
  final int timestamp;
  final List<dynamic> transactions;
  final String validator;
  final String signature;

  const BlockModel({
    required this.index,
    required this.hash,
    required this.prevHash,
    required this.timestamp,
    required this.transactions,
    required this.validator,
    required this.signature,
  });

  @override
  List<Object> get props => [
        index,
        hash,
        prevHash,
        timestamp,
        transactions,
        validator,
        signature,
      ];

  factory BlockModel.fromJson(Map<String, dynamic> json) {
    return BlockModel(
      index: json['Index'] ?? 0,
      hash: json['Hash'] ?? '',
      prevHash: json['PrevHash'] ?? '',
      timestamp: json['Timestamp'] ?? 0,
      transactions: json['Transactions'] ?? [],
      validator: json['Validator'] ?? '',
      signature: json['Signature'] ?? '',
    );
  }
}
