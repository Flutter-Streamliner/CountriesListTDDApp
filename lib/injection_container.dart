import 'package:countries_ttd/core/network/network_info.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_local_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/datasources/country_remote_datasource.dart';
import 'package:countries_ttd/features/countries_list/data/repositories/country_repository_impl.dart';
import 'package:countries_ttd/features/countries_list/domain/repositories/country_repository.dart';
import 'package:countries_ttd/features/countries_list/domain/usecases/get_all_countries.dart';
import 'package:countries_ttd/features/countries_list/presentation/bloc/country_bloc.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  // ! Features 
  // Bloc
  serviceLocator.registerFactory(
    () => CountryBloc(getAllCountriesUseCase: serviceLocator())
  );
  // Use cases
  serviceLocator.registerLazySingleton(() => GetAllCountriesUseCase(repository: serviceLocator()));
  // Repository
  serviceLocator.registerLazySingleton<CountryRepository>(() => 
    CountryRepositoryImpl(
      localDataSource: serviceLocator(),
      remoteDataSource: serviceLocator(),
      networkInfo: serviceLocator(),
    ));
  // Data sources
  serviceLocator.registerLazySingleton<CountryRemoteDataSource>(
    () => CountryRemoteDataSourceImpl(client: serviceLocator())
  );
  serviceLocator.registerLazySingleton<CountryLocalDataSource>(
    () => CountryLocalDataSourceImpl(sharedPreferences: serviceLocator())
  );
  // ! Core
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectionChecker: serviceLocator()));
  // ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton(() => sharedPreferences);
  serviceLocator.registerLazySingleton(() => http.Client);
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}