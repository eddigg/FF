import 'package:equatable/equatable.dart';

class Contract extends Equatable {
  final String address;
  final String name;
  final String bytecode;
  final DateTime timestamp;
  final Map<String, dynamic> abi;

  const Contract({
    required this.address,
    required this.name,
    required this.bytecode,
    required this.timestamp,
    required this.abi,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      address: json['address'] as String,
      name: json['name'] as String,
      bytecode: json['bytecode'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      abi: json['abi'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'name': name,
      'bytecode': bytecode,
      'timestamp': timestamp.toIso8601String(),
      'abi': abi,
    };
  }

  Contract copyWith({
    String? address,
    String? name,
    String? bytecode,
    DateTime? timestamp,
    Map<String, dynamic>? abi,
  }) {
    return Contract(
      address: address ?? this.address,
      name: name ?? this.name,
      bytecode: bytecode ?? this.bytecode,
      timestamp: timestamp ?? this.timestamp,
      abi: abi ?? this.abi,
    );
  }

  @override
  List<Object?> get props => [
        address,
        name,
        bytecode,
        timestamp,
        abi,
      ];
}
