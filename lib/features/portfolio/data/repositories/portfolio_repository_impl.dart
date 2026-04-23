import 'package:dartz/dartz.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';
import '../models/portfolio_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioLocalDataSource dataSource;

  const PortfolioRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, PortfolioEntity>> getPortfolioData() async {
    try {
      final map = await dataSource.getPortfolioData();
      final entity = PortfolioModel.fromMap(map);
      return Right(entity);
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(
        type: ErrorType.unknown,
        message: e.toString(),
      ));
    }
  }
}
