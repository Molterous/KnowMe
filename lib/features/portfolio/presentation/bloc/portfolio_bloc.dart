import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/usecases/get_portfolio_data.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final GetPortfolioData _getPortfolioData;

  PortfolioBloc(this._getPortfolioData) : super(const PortfolioState()) {
    on<PortfolioDataRequested>(_onDataRequested);
  }

  Future<void> _onDataRequested(
    PortfolioDataRequested event,
    Emitter<PortfolioState> emit,
  ) async {
    emit(state.copyWith(status: PortfolioStatus.loading));

    final result = await _getPortfolioData();

    result.fold(
      (failure) => emit(state.copyWith(
        status: PortfolioStatus.failure,
        error: failure,
      )),
      (data) => emit(state.copyWith(
        status: PortfolioStatus.success,
        data: data,
      )),
    );
  }
}
