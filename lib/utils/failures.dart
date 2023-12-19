import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

class ServerFailure extends Failure {
  final num? statusCode;
  final String? errorMessage;
  ServerFailure({this.errorMessage, this.statusCode});
}

class DioFailure extends Failure {}

class ParsingFailure extends Failure {
  final String errorMessage;
  ParsingFailure({required this.errorMessage});
}

class OtherFailure extends Failure {
  final String errorMessage;
  OtherFailure({required this.errorMessage});
}

class CacheFailure extends Failure {}
