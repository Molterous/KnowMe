import 'package:dartz/dartz.dart';
import '../../../../core/error/exception_mapper.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/portfolio_entity.dart';
import '../../domain/repositories/portfolio_repository.dart';
import '../datasources/portfolio_local_datasource.dart';
import '../datasources/portfolio_remote_datasource.dart';
import '../models/portfolio_model.dart';

class PortfolioRepositoryImpl implements PortfolioRepository {
  final PortfolioRemoteDataSource remoteDataSource;
  final PortfolioLocalDataSource localDataSource;

  const PortfolioRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PortfolioEntity>> getPortfolioData() async {
    try {
      final map = await _fetchWithFallback();
      return Right(PortfolioModel.fromMap(map));
    } on AppException catch (e) {
      return Left(mapExceptionToFailure(e));
    } catch (e) {
      return Left(Failure(type: ErrorType.unknown, message: e.toString()));
    }
  }

  Future<Map<String, dynamic>> _fetchWithFallback() async {
    try {
      return await remoteDataSource.getPortfolioData();
    } catch (_) {
      return await localDataSource.getPortfolioData();
    }
  }
}
