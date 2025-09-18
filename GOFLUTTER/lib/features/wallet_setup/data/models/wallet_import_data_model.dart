
import 'package:equatable/equatable.dart';

class WalletImportDataModel extends Equatable {
  final String? privateKey;
  final String? fileContent;
  final String? password;

  const WalletImportDataModel({
    this.privateKey,
    this.fileContent,
    this.password,
  });

  @override
  List<Object> get props => [privateKey ?? '', fileContent ?? '', password ?? ''];
}
