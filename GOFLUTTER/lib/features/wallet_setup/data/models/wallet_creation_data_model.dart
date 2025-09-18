
import 'package:equatable/equatable.dart';

class WalletCreationDataModel extends Equatable {
  final String password;

  const WalletCreationDataModel({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}
