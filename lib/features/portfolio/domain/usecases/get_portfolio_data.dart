import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/portfolio_entity.dart';
import '../repositories/portfolio_repository.dart';

class GetPortfolioData {
  final PortfolioRepository repository;

  const GetPortfolioData(this.repository);

  Future<Either<Failure, PortfolioEntity>> call() =>
      repository.getPortfolioData();
}
