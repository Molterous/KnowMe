import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/portfolio_entity.dart';

abstract class PortfolioRepository {
  Future<Either<Failure, PortfolioEntity>> getPortfolioData();
}
