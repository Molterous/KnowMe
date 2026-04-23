part of 'portfolio_bloc.dart';

enum PortfolioStatus { initial, loading, success, failure }

class PortfolioState extends Equatable {
  final PortfolioStatus status;
  final PortfolioEntity? data;
  final Failure? error;

  const PortfolioState({
    this.status = PortfolioStatus.initial,
    this.data,
    this.error,
  });

  PortfolioState copyWith({
    PortfolioStatus? status,
    PortfolioEntity? data,
    Failure? error,
  }) =>
      PortfolioState(
        status: status ?? this.status,
        data: data ?? this.data,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [status, data, error];
}
