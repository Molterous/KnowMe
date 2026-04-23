part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  const PortfolioEvent();

  @override
  List<Object> get props => [];
}

class PortfolioDataRequested extends PortfolioEvent {
  const PortfolioDataRequested();
}
