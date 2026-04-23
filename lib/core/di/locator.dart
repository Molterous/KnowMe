import 'package:get_it/get_it.dart';
import '../../features/portfolio/data/datasources/portfolio_local_datasource.dart';
import '../../features/portfolio/data/repositories/portfolio_repository_impl.dart';
import '../../features/portfolio/domain/repositories/portfolio_repository.dart';
import '../../features/portfolio/domain/usecases/get_portfolio_data.dart';
import '../../features/portfolio/presentation/bloc/portfolio_bloc.dart';

final sl = GetIt.instance;

void setupLocator() {
  // datasource
  sl.registerLazySingleton<PortfolioLocalDataSource>(
    () => PortfolioLocalDataSourceImpl(),
  );

  // repository
  sl.registerLazySingleton<PortfolioRepository>(
    () => PortfolioRepositoryImpl(sl()),
  );

  // usecase
  sl.registerLazySingleton(() => GetPortfolioData(sl()));

  // bloc — factory so each registration creates a fresh instance
  sl.registerFactory(() => PortfolioBloc(sl()));
}
