import 'package:equatable/equatable.dart';

enum ErrorType { asset, parse, network, unknown }

class Failure extends Equatable {
  final ErrorType type;
  final String message;

  const Failure({required this.type, required this.message});

  @override
  List<Object> get props => [type, message];
}
